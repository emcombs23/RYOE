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