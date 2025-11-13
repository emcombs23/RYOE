select *
from plays;

Select rusher_player_name, ydstogo, yards_gained
from plays
where rush_attempt = 1;


Select  ydstogo, avg(yards_gained)
from plays
where rush_attempt = 1
group by ydstogo;


Select rusher_player_name, ydstogo, yards_gained, (0.12588674101163447*ydstogo + 3.4733651935608076)as x_yds_gained, (yards_gained - (0.12588674101163447*ydstogo + 3.4733651935608076)) as RYOE
from plays
where rush_attempt = 1;


With RYOE_table As(
Select rusher_player_name, ydstogo, yards_gained, (0.12588674101163447*ydstogo + 3.4733651935608076)as x_yds_gained, (yards_gained - (0.12588674101163447*ydstogo + 3.4733651935608076)) as RYOE
From plays
Where rush_attempt = 1
)
Select rusher_player_name, avg(RYOE) as avg_RYOE, count(*) as rush_attempts
From RYOE_table
Group By rusher_player_name
Having rush_attempts >= 100
Order By avg_RYOE DESC;


Select rusher_player_name, ydstogo, yards_gained,
CASE WHEN CAST(down AS INTEGER) = 2 THEN 1 ELSE 0 END AS seconddown,
CASE WHEN CAST(down AS INTEGER) = 3 THEN 1 ELSE 0 END AS thirddown,
CASE WHEN CAST(down AS INTEGER) = 4 THEN 1 ELSE 0 END AS fourthdown
from plays
where rush_attempt = 1;


WITH xYards AS(
With play_data As(
Select rusher_player_name, ydstogo, yards_gained,
CASE WHEN CAST(down AS INTEGER) = 2 THEN 1 ELSE 0 END AS seconddown,
CASE WHEN CAST(down AS INTEGER) = 3 THEN 1 ELSE 0 END AS thirddown,
CASE WHEN CAST(down AS INTEGER) = 4 THEN 1 ELSE 0 END AS fourthdown
from plays
where rush_attempt = 1
)
Select rusher_player_name, ydstogo, yards_gained, (0.199273*ydstogo+ 0.73200072*seconddown + 1.12417315*thirddown + 0.82187461*fourthdown + 2.471750805961095)AS x_yds_gained
from play_data
)Select rusher_player_name, avg((yards_gained - x_yds_gained)) AS RYOE
From xYards
Group By rusher_player_name
Having count(*) >= 100
Order By RYOE DESC;



