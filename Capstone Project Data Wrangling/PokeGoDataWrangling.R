install.packages(c("tidyr", "dplyr", "ggplot2"))
library("tidyr")
library("dplyr")
library("ggplot2")

#load in the csv file
#I couldn't upload the csv file to github due to size, so view this code as an example
PokeGo_original <- read.csv(file = "C://Users//hcnur_000//Desktop//Capstone Project//Capstone Project Data Wrangling//PokeGo_original.csv", as.is = T)
View(PokeGo_original)  #this may take a while because of the size of the dataset

#picked the columns that I thought were most useful
PokeGo_clean <- select(PokeGo_original, pokemonId, appearedTimeOfDay, appearedDayOfWeek, terrainType:closeToWater,
                       weather, population_density, gymDistanceKm, pokestopDistanceKm)
View(PokeGo_clean)

#arranged in order by pokemon
PokeGo_clean <- PokeGo_clean %>% arrange(pokemonId)

#check for na and blank values
sum(is.na(PokeGo_clean))  #says that there are 0 na values
sum(PokeGo_clean == "")  #also says that there are 0 blank values, this makes things a little easier

#I noticed there were no Monday values in the appearedDayOfWeek column
#Here's the fix:
PokeGo_clean$appearedDayOfWeek <- gsub("dummy_day", "Monday", PokeGo_clean$appearedDayOfWeek, ignore.case = T)

#Here's a link for the meaning of the numbers in the terrainType column:
#http://glcf.umd.edu/data/lc/
#Here's a link for the pokemon Id's in the pokemonId column:
#https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Kanto_Pok%C3%A9dex_number

#Lets change the km distance columns to meters, because it's easier to read next to the other columns
PokeGo_clean$gymDistanceKm <- PokeGo_clean$gymDistanceKm * 1000
PokeGo_clean$pokestopDistanceKm <- as.numeric(PokeGo_clean$pokestopDistanceKm) * 1000
#This created 39 NA values in the pokestop distance, so lets change that to the mean of each pokestop
mean(PokeGo_clean$pokestopDistanceKm, na.rm = T)  #695.836 is the mean
PokeGo_clean$pokestopDistanceKm[is.na(PokeGo_clean$pokestopDistanceKm)] <- mean(PokeGo_clean$pokestopDistanceKm, na.rm = T)
#Now lets change the titles of those columns to have m instead of km
colnames(PokeGo_clean)[8] <- "gymDistance_m"
colnames(PokeGo_clean)[9] <- "pokestopDistance_m"
#Lets save this dataset
write.csv(PokeGo_clean, "C://Users//hcnur_000//Desktop//PokeGo_clean.csv")

#Lets make a water dataset to test water pokemon near water
PokeGo_water2water <- filter(PokeGo_clean, pokemonId == c(7:9, 54:55, 60:62, 72:73, 79:80, 86:87, 90:91, 98:99,
                                                          116:121, 129:131, 134, 138:141)) %>%
    select(pokemonId, closeToWater)
View(PokeGo_water2water)
#Lets make another water dataset to test non-water pokemon near water
#This way we can compare the two datasets
PokeGo_notwater2water <- filter(PokeGo_clean, pokemonId == c(1:6, 10:53, 56:59, 63:71, 74:78, 81:85, 88:89,
                                                             92:97, 100:115, 122:128, 132:133, 135:137, 142:151)) %>%
    select(pokemonId, closeToWater)
View(PokeGo_notwater2water)

#Lets save these new datasets
write.csv(PokeGo_water2water, "C://Users//hcnur_000//Desktop//PokeGo_water2water.csv")
write.csv(PokeGo_notwater2water, "C://Users//hcnur_000//Desktop//PokeGo_notwater2water.csv")
