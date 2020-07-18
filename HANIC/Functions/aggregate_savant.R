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


aggregate_savant <- function(df_savant_BatRuns_season, df_savant_FrameRuns_season, df_savant_DEFRuns_season){
  
  #condense all csvs to be at the player-season level 
  
  #batters
  
  df_batters_season <- df_savant_BatRuns_season %>%
    select(player_id, last_name, first_name, year, pa, bip, woba, est_woba)
  
  df_oaa_season <- df_savant_DEFRuns_season %>%
    select(player_id, year, primary_pos_formatted, fielding_runs_prevented)
  
  df_frame_season <- df_savant_FrameRuns_season %>%
    mutate(player_id=fielder_2) %>%
    select(player_id, year, runs_extra_strikes)
  
  #join all dfs together
  
  df_batters_season <- df_batters_season %>%
    left_join(df_oaa_season, by=c('player_id', 'year')) %>%
    left_join(df_frame_season, by=c('player_id', 'year'))

  return(df_batters_season)

  rm(df_savant_BatRuns_season, df_savant_FrameRuns_season, df_savant_DEFRuns_season)
  
  
}