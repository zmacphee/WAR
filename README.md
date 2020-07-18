# WAR
Hacking together a WAR metric with Baseball Savant and Fangraphs


**System Requirements**

This code runs on rand requires tidyverse. If you do not have that installed, I've got a pacman function at the top of the script that will auto do that for you

**Project Overview**

Project is designed to calcualte two disctinct types of WAR metrics using novel Baseball Savant data and fangraphs data. The purpose of this repo is to expose one to the player evaluation WAR logic and calculate that metric for all MLB players 2017-2019. 

**Getting Started**

Enter Hanic folder and open up the project workspace `WAR.rproj`. Choose which `cal_WAR_` script to run first and you are off to the races.

**Room for Improvement**	

	  1. Park effects on measurements
	  2. A statcast baserunning metric
	  3. Control outcomes for pitch quality
	  4. Measure pitch quality using expected framework
	  5. Update positional adjustments
	  6. Update leverage numbers
	  7. Control for catcher framing in Pitcher WAR
	  8. League and component adjustments
	  9. Insure Batting runs sum to 0
	  10. Insure Batting WAR sums to 570
	  11. Insure Pitching WAR sums to 430
	  12. Split by player team
 
 **Resources**		
 
	1. Fangraphs Guts https://www.fangraphs.com/guts.aspx?type=cn
	2. Fangraphs Leaderboards https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=y&type=8&season=2019&month=0&season1=2019&ind=0
	3. Baseball Savant https://baseballsavant.mlb.com/leaderboard/expected_statistics
