#!/usr/bin/env python3
"""Create an SQLite database `plays.db` from `plays.csv` using pandas.

Usage: python scripts/create_sqlite.py

This script will write (and overwrite) `plays.db` in the repository root and
create a single table named `plays` containing the CSV content.
"""
from pathlib import Path
import sqlite3
import sys

import pandas as pd


def find_csv(root: Path) -> Path:
    # Prefer repo root ./plays.csv, but try a few common locations
    candidates = [root / "plays.csv", Path.cwd() / "plays.csv"]
    for p in candidates:
        if p.exists():
            return p
    raise FileNotFoundError("plays.csv not found in repository root or current working directory")


def main() -> int:
    repo_root = Path(__file__).resolve().parents[1]
    csv_path = find_csv(repo_root)
    db_path = repo_root / "plays.db"

    print(f"Reading CSV from: {csv_path}")
    # read with low_memory=False to reduce dtype inference warnings for wide CSVs
    df = pd.read_csv(csv_path, low_memory=False)

    # remove existing DB to ensure the resulting DB contains only the `plays` table
    if db_path.exists():
        print(f"Removing existing DB at {db_path}")
        db_path.unlink()

    print(f"Writing SQLite DB to: {db_path} (table name: plays)")
    conn = sqlite3.connect(db_path)
    try:
        df.to_sql("plays", conn, if_exists="replace", index=False)

        # verify
        cur = conn.cursor()
        cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
        tables = [r[0] for r in cur.fetchall()]
        print(f"Tables in DB: {tables}")

        cur.execute("SELECT COUNT(*) FROM plays")
        row_count = cur.fetchone()[0]
        print(f"Inserted rows: {row_count}")
    finally:
        conn.close()

    print("Done.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
