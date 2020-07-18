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


##$$$$$$$$$$$$$$$$$$$$##
#### Read in Data!!! ####
##$$$$$$$$$$$$$$$$$$$$#

#primary key between MLBAM + Fangraphs... lot of online options 
key<-read.csv('Data\\Chadwick_Key\\Player_Key.csv')

#read in savant data
#2019
df_pitchers_2019 <- read.csv('Data\\2019_Savant\\Pitchers.csv')

#2018
df_pitchers_2018 <- read.csv('Data\\2018_Savant\\Pitchers.csv')

#2017
df_pitchers_2017 <- read.csv('Data\\2017_Savant\\Pitchers.csv')

#rbind all savant data and get cooking

df_pitchers_all_savant<-rbind(df_pitchers_2019, df_pitchers_2018, df_pitchers_2017)

rm(df_pitchers_2017,
   df_pitchers_2018,
   df_pitchers_2019)

#read in fangraphs data



df_fg_2019_pitchers <- read.csv('Data\\Fangraphs\\FG_2019_Pitchers.csv')
df_fg_2019_pitchers$year<-2019
df_fg_2018_pitchers <- read.csv('Data\\Fangraphs\\FG_2018_Pitchers.csv')
df_fg_2018_pitchers$year<-2018
df_fg_2017_pitchers <- read.csv('Data\\Fangraphs\\FG_2017_Pitchers.csv')
df_fg_2017_pitchers$year<-2017

#rbind data and remove individual years
fg_pitchers<-rbind(df_fg_2019_pitchers, df_fg_2018_pitchers, df_fg_2017_pitchers)

rm(df_fg_2019_pitchers, df_fg_2018_pitchers, df_fg_2017_pitchers)


#join key and select and join relavant fangraphs info
df_pitchers_all_savant<-left_join(df_pitchers_all_savant, key, by="player_id")
fg_pitchers<-select(fg_pitchers, playerid, year,G, GS,  IP,ERA, WAR, gmLI)
df_pitchers_all_savant<-mutate(df_pitchers_all_savant, playerid=as.character(playerid))
df_pitchers_all_savant<-mutate(df_pitchers_all_savant, playerid=as.numeric(playerid))
df_pitchers_all_savant<-left_join(df_pitchers_all_savant, fg_pitchers, by = c("year", "playerid"))


###grab functions!
woba_avg <- get_woba_avg()
woba_scale <- get_woba_scale()
rpw <- get_rpw()

#join relavant information in calc war
df_pitchers_all_savant <- left_join(df_pitchers_all_savant, woba_avg, by="year")
df_pitchers_all_savant<- left_join(df_pitchers_all_savant, woba_scale, by="year")
df_pitchers_all_savant<-left_join(df_pitchers_all_savant, rpw, by='year')


#take woba reduce down to runs (divide by woba scale) and scale to per 9
df_pitchers_all_savant<-mutate(df_pitchers_all_savant, ra_pa=(est_woba/woba_scale)-(woba_avg/woba_scale))
df_pitchers_all_savant<-mutate(df_pitchers_all_savant, xRA9=4.45+(37.5*ra_pa))

#calculate WAR!
df_pitchers_all_savant<-mutate(df_pitchers_all_savant, dRuns=(((((18 -IP/G)*(4.45)) + ((IP/G)*xRA9)) / 18)+2)*1.5, 
                               Replacement_Runs=.03*(1-GS/G) + 0.12*(GS/G), 
                               RAAp9=4.45-xRA9, 
                               WAAp9=RAAp9/dRuns, 
                               BS_WAR=(WAAp9+Replacement_Runs)*(IP/9))


#apply leverage inflation
df_pitchers_all_savant<-mutate(df_pitchers_all_savant, lev=(1+gmLI)/2, 
                               GS_perc=ifelse(GS==0, 0,G/GS),
                               Role=ifelse(GS_perc>.7, "S", "R"), 
                               BS_WAR=ifelse(Role=="S", BS_WAR, BS_WAR*lev), 
                               DIFF=BS_WAR-WAR)

#Rename fangraphs for plotting
df_pitchers_all_savant<-df_pitchers_all_savant%>%rename(fWAR=WAR)

#make a nice plot
ggplot(df_pitchers_all_savant, aes(x=BS_WAR, y=fWAR)) + 
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+ggtitle('Pitching: BS_WAR vs fWAR 2017-2019')+
  theme(plot.title = element_text(hjust = 0.5))



#enjoy the fruits of your labor!

View(df_pitchers_all_savant)

