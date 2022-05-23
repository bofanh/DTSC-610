library(dplyr)
library("RSocrata")

df <- read.socrata(
  "https://data.cdc.gov/resource/9mfq-cb36.json",
  app_token = "my token", # get a personal token from the CDC website.
  email     = "username", 
  password  = "password"
)

# get newest data
get.newest.data <- function(df){
  mostrecentdate <-  df[rev(order(as.Date(df$submission_date, format="%Y-%M-%D"))),]
  mostrecentdate <- dplyr::select(mostrecentdate, -c("conf_cases","prob_cases","pnew_case","created_at","consent_cases","consent_deaths","pnew_death","conf_death","prob_death"))
  mostrecentdate <- mostrecentdate[!(mostrecentdate$state=="NYC" | mostrecentdate$state=="FSM"| mostrecentdate$state=="RMI"),]
  mostrecentdate <- mostrecentdate[!(mostrecentdate$state=="PR"|mostrecentdate$state=="GU"|mostrecentdate$state=="MP"|mostrecentdate$state=="VI"),]
  mostrecentdate <- mostrecentdate[!(mostrecentdate$state=="AS"|mostrecentdate$state=="PW"),]
  day1 <- mostrecentdate$submission_date[1]
  day1 <- substr(day1,0,10)
  mostrecentdate <- mostrecentdate[mostrecentdate$submission_date == day1,]
  mostrecentdate <- mostrecentdate[order(mostrecentdate$state),]
  
  write.csv(mostrecentdate,"today_dataframe.csv", row.names = FALSE)
}

# 
get.all.data <- function(df){
  df2 <- dplyr::select(df, -c("conf_cases","prob_cases","pnew_case","created_at","consent_cases","consent_deaths","pnew_death","conf_death","prob_death"))
  df2 <- df2[!(df2$state=="NYC" | df2$state=="FSM"| df2$state=="RMI"),]
  df2 <- df2[!(df2$state=="PR"|df2$state=="GU"|df2$state=="MP"|df2$state=="VI"),]
  df2 <- df2[!(df2$state=="AS"|df2$state=="PW"),]
  df2 <- df2[order(df2$state),]
  
  write.csv(df2,"all_dataframe.csv", row.names = FALSE)
}

get.all.data(df)