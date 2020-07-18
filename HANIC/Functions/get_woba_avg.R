## Description: Function that takes discrete savant data and aggaregates it all at the player-season level
## Author: Zane MacPhee, July 2020
## Edited by:
## Inputs: - Batters Savant CSV with xwoba and # of PA per year
##         - Pitchers Savant CSV with xwoba and # of PA per year
##         - Fielders Savant CSV with OAA and POS per year
##         - Framing Savant CSV with runs saved per year
##
## Outputs: - df_savant_hitters is a data frame that combines all savant components into one df for hitters
## Notes:   - df_savant_pitchers is a data frame that combines all savant componenets into one df for pitchers


get_woba_avg <- function(){
  
 year <- c(2019, 2018, 2017)
 woba_avg <-c(.319, .315, .325)
 
 woba_avg <-as.data.frame(cbind(year, woba_avg))
 
  return(woba_avg)
  

  
}