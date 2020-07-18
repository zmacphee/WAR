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


get_rpw <- function(){
  
  year <- c(2019, 2018, 2017)
  rpw <-c(10.296, 9.714, 10.048)
  
  rpw <-as.data.frame(cbind(year, rpw))
  
  return(rpw)
  
  
  
}