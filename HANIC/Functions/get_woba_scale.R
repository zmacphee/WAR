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


get_woba_scale<- function(){
  
  year <- c(2019, 2018, 2017)
  woba_scale <-c(1.157, 1.226, 1.185)
  
  woba_scale <-as.data.frame(cbind(year, woba_scale))
  
  return(woba_scale)
  
  
  
}