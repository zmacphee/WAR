##$$$$$$$$$$$$$$$$$$$##
#### Load packages ####
##$$$$$$$$$$$$$$$$$$$##

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)


##$$$$$$$$$$$$$$$$$$$$##
#### Load functions ####
##$$$$$$$$$$$$$$$$$$$$##
source(file.path("Functions", "aggregate_savant.R"))
source(file.path("Functions", "get_woba_avg.R"))
source(file.path("Functions", "get_woba_scale.R"))
source(file.path("Functions", "get_rpw.R"))


##$$$$$$$$$$$$$$$$##
#### Read in Data##

#primary key between MLBAM + Fangraphs... lot of online options 
key<-read.csv('Data\\Chadwick_Key\\Player_Key.csv')

#load in and bind fangraphs data

df_fg_2019_batters <- read.csv('Data\\Fangraphs\\FG_2019_Batters.csv')
df_fg_2019_batters$year<-2019
df_fg_2018_batters <- read.csv('Data\\Fangraphs\\FG_2018_Batters.csv')
df_fg_2018_batters$year<-2018
df_fg_2017_batters <- read.csv('Data\\Fangraphs\\FG_2017_Batters.csv')
df_fg_2017_batters$year<-2017

#bind them together and remove individual years
fg_batters<-rbind(df_fg_2019_batters, df_fg_2018_batters, df_fg_2017_batters)
rm(df_fg_2017_batters, df_fg_2018_batters, df_fg_2019_batters)


#time for savant data!
#2019
df_batters_2019 <- read.csv('Data\\2019_Savant\\Batters.csv')
df_oaa_2019 <- read.csv('Data\\2019_Savant\\OAA.csv')
df_frame_2019 <- read.csv('Data\\2019_Savant\\Framing.csv')

#2018
df_batters_2018 <- read.csv('Data\\2018_Savant\\Batters.csv')
df_oaa_2018 <- read.csv('Data\\2018_Savant\\OAA.csv')
df_frame_2018 <- read.csv('Data\\2018_Savant\\Framing.csv')

#2017
df_batters_2017 <- read.csv('Data\\2017_Savant\\Batters.csv')
df_oaa_2017 <- read.csv('Data\\2017_Savant\\OAA.csv')
df_frame_2017 <- read.csv('Data\\2017_Savant\\Framing.csv')

#rbind all savant data and get cooking

df_batters_all_savant<-rbind(df_batters_2019, df_batters_2018, df_batters_2017)
df_oaa_all_savant<-rbind(df_oaa_2019, df_oaa_2018, df_oaa_2017)
df_frame_all_savant<-rbind(df_frame_2019, df_frame_2018, df_frame_2017)

#remove individual years
rm(df_batters_2017,
   df_oaa_2017,
   df_frame_2017,
   df_batters_2018,
   df_oaa_2018,
   df_frame_2018,
   df_batters_2019,
   df_oaa_2019,
   df_frame_2019)



#aggregate all savant data and remove individual component data frames
df_batters_savant<-aggregate_savant(df_batters_all_savant, df_frame_all_savant,df_oaa_all_savant )
rm(df_batters_all_savant, df_frame_all_savant, df_oaa_all_savant)


##$$$$$$$$$$$$$$$$##
#### Run Functions##
##$$$$$$$$$$$$$$$$##
woba_avg <- get_woba_avg()
woba_scale <- get_woba_scale()
rpw <- get_rpw()

#join additional data (rpw, woba_scales+averages)
df_batters_savant <- left_join(df_batters_savant, woba_avg, by="year")
df_batters_savant <- left_join(df_batters_savant, woba_scale, by="year")

#calculate batting runs
df_batters_savant <- df_batters_savant %>%
  mutate(Batting_Runs=(est_woba-woba_avg)/woba_scale * pa)

#if na for fielding runs and framing runs, give player 0
df_batters_savant <- df_batters_savant %>%
  mutate(runs_extra_strikes=ifelse(is.na(runs_extra_strikes)==TRUE, 0, runs_extra_strikes), 
         fielding_runs_prevented=ifelse(is.na(fielding_runs_prevented)==TRUE, 0, fielding_runs_prevented))

#add fielding runs and framing runs and call this RSAA (Runs saved above average)
df_batters_savant <- df_batters_savant %>%
  mutate(RSAA=fielding_runs_prevented+runs_extra_strikes)


#need to calculate lg_pa for replacelement level runs... good thing it exists in data!
lg_pa <- df_batters_savant%>%group_by(year)%>%summarise(lg_pa=sum(pa))

#join and calculate repalcement level runs
df_batters_savant <- left_join(df_batters_savant, lg_pa)
df_batters_savant <- left_join(df_batters_savant, rpw)


df_batters_savant <- df_batters_savant %>%
  mutate(Replacement_Runs=570 * rpw/lg_pa *pa )


#now start joining with FG
#primary key
df_batters_savant<-left_join(df_batters_savant, key)

#select relevant fields from fangraphs csv and make play nice as key
fg_batters <-select(fg_batters, playerid, year, Pos, Off, Def, BsR, WAR)
df_batters_savant<-mutate(df_batters_savant, playerid=as.character(playerid))
df_batters_savant<-mutate(df_batters_savant, playerid=as.numeric(playerid))

#join fangraphs
df_batters_savant<-left_join(df_batters_savant, fg_batters)


#calculate WAR, and DIFF between two systems
df_batters_savant <- df_batters_savant %>%
  mutate(BS_WAR=(Batting_Runs+RSAA+Pos+BsR+Replacement_Runs)/rpw, 
         DIFF=BS_WAR-WAR)

#rename fangraphs war to fWAR
df_batters_savant<-df_batters_savant%>%rename(fWAR=WAR)

#make a nice plot
ggplot(df_batters_savant, aes(x=BS_WAR, y=fWAR)) + 
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+ggtitle('Batting: BS_WAR vs fWAR 2017-2019')+
  theme(plot.title = element_text(hjust = 0.5))

#check out the leaderboards!

View(df_batters_savant)
