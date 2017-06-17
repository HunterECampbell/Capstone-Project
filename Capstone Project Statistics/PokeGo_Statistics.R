library(ggplot2)
library(tidyr)
library(dplyr)

PokeGo_clean <- read.csv(file = "C:/Users/hcnur_000/Desktop/Capstone Project/Capstone Project Data Wrangling/PokeGo_clean.csv")
PokeGo_water2water <- read.csv(file = "C:/Users/hcnur_000/Desktop/Capstone Project/Capstone Project Data Wrangling/PokeGo_water2water.csv")
PokeGo_notwater2water <- read.csv(file = "C:/Users/hcnur_000/Desktop/Capstone Project/Capstone Project Data Wrangling/PokeGo_notwater2water.csv")
View(PokeGo_clean)
View(PokeGo_water2water)
View(PokeGo_notwater2water)

#needed to get rid of the X columns for all of the datasets
PokeGo_clean <- select(PokeGo_clean, -X)
PokeGo_water2water <- select(PokeGo_water2water, -X)
PokeGo_notwater2water <- select(PokeGo_notwater2water, -X)


##CALCULATIONS
summary(PokeGo_clean)
summary(PokeGo_water2water)
summary(PokeGo_notwater2water)

#Lets calculate the probability of water2water vs notwater2water
#Water type Pokemon vs. close to water:
437/(761+437)  #36.48%
#Non-water type Pokemon vs. close to water:
441/(1722+441)  #20.39%
#That's not much of a difference, but you have a 16% higher chance
#of seeing a water type Pokemon near water vs. a non-water type Pokemon
#near water.


##CORRELATIONS
hetcor(PokeGo_clean)
#Looks like the highest correlations are pokemonId w/ population_density
#and pokemonId w/ closeToWater, pokemonId is next closest to terrainType
#and weather.  That's quite interesting.
hetcor(PokeGo_water2water)
#This correlation is 0.0272
hetcor(PokeGo_notwater2water)
#This correlation is 0.04632, which is better than water2water's

##GRAPHS
#PokeGo_clean
ggplot(PokeGo_clean, aes(pokemonId)) +
  geom_bar(fill = "red") +
  labs(x = "Pokemon Id", y = "Pokemon Appearances")
#This shows the distribution of Pokemon sightings
#It looks like there is a large number of Pokemon being spawned between
#10-25 (especially), 40-50, 95-100, and 130-135
ggplot(PokeGo_clean, aes(pokemonId, population_density)) +
  geom_point(shape = 1, alpha = .1) +
  geom_density2d(color = "red", size = 1) +
  labs(x = "Pokemon Id", y = "Population Density")
#This makes sense that our density is around the mean of population_density (1313.6)
#Again it seems we have peeks around the same area as the above graph.
#Here's another visualization of the same graph:
ggplot(PokeGo_clean, aes(pokemonId, population_density)) +
  geom_smooth() +
  labs(x = "Pokemon Id", y = "Population Density")
#This visualization is easier to read because it zooms into the main part
#of the population_density data.  Most of the data was taken in a population
#density of 1313, so it would make sense that there wouldn't
#high density populations shown on this graph.  It's interesting that there
#is a drop in the more common Pokemon (found in the pokemonId graph) and a
#rise in the more rare Pokemon, but that it drops towards the end.
ggplot(PokeGo_clean, aes(closeToWater, fill = closeToWater)) +
  geom_bar() +
  labs(x = "Close To Water", y = "Appearances of All Pokemon Types", fill = "Close To Water")
#This shows the distribution of all Pokemon near water
ggplot(PokeGo_clean, aes(terrainType)) +
  geom_bar(fill = "steelblue") +
  labs(x = "Terrain Type", y = "Pokemon Appearances")
#This shows the distribution of terrainType
ggplot(PokeGo_clean, aes(appearedTimeOfDay)) +
  geom_bar(fill = "steelblue") +
  labs(x = "Time of Day", y = "Pokemon Appearances")
#This shows the distribution of what time during the day Pokemon are
#most often found.  It's interesting that night time is the highest frequency rate.
#This must mean that PokemonGo players play most often during this time.
ggplot(PokeGo_clean, aes(appearedDayOfWeek)) +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = c("Monday", "Tuesday", "Wednesday", "Thursday",
                              "Friday", "Saturday", "Sunday")) +
  labs(x = "Day of Week", y = "Pokemon Appearances")
#This shows what days during the week PokemonGo is most often played.
#Looks like the weekend is played the most, as long as Wednesday and Thurday.
ggplot(PokeGo_clean, aes(weather)) +
  geom_bar(fill = "steelblue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .25)) +
  labs(x = "Weather", y = "Pokemon Appearances")
#This shows that PokemonGo is most often played during good weather
ggplot(PokeGo_clean, aes(pokemonId, gymDistance_m)) +
  geom_point(shape = 1, alpha = .1) +
  coord_cartesian(ylim = c(0, 1e+05)) +
  labs(x = "Pokemon Id", y = "Gym Distance in Meters")
#This shows Pokemon density is higher around gyms. Perhaps this also means
#that PokemonGo players spend most of their time around gyms?
ggplot(PokeGo_clean, aes(pokemonId, gymDistance_m)) +
  geom_smooth() +
  labs(x = "Pokemon Id", y = "Gym Distance in Meters")
#This is another visualization of the same gym distance graph above.  It's
#interesting that there is a drop in density with the more common Pokemon (found in
#our pokemonId column).  It's also interesting that less common
#Pokemon are found more often around gyms (and more common Pokemon are
#found less often around gyms).
ggplot(PokeGo_clean, aes(pokemonId, pokestopDistance_m)) +
  geom_point(shape = 1, alpha = .1) +
  coord_cartesian(ylim = c(0, 1e+05)) +
  labs(x = "Pokemon Id", y = "Pokestop Distance in Meters")
#This shows the same results as the gym graphs.  The closer to 0, the closer
#you are to a pokestop. So, there is a higher density of Pokemon near pokestops.
ggplot(PokeGo_clean, aes(pokemonId, pokestopDistance_m)) +
  geom_smooth() +
  labs(x = "Pokemon Id", y = "Pokestop Distance in Meters")
#Looks like we have fairy similar results to the gym distance graph. There's
#a similar frequency of Pokemon except for the rare types around 1-20.

#PokeGo_water2water
ggplot(PokeGo_water2water, aes(closeToWater, fill = closeToWater)) +
  geom_bar() +
  labs(x = "Close to Water", y = "Appearances of Water Type Pokemon",
       fill = "Close To Water")

#This shows the distribution of water type Pokemon near water

#PokeGo_notwater2water
ggplot(PokeGo_notwater2water, aes(closeToWater, fill = closeToWater)) +
  geom_bar() +
  labs(x = "Close to Water", y = "Appearances of Non-water Type Pokemon",
       fill = "Close To Water")
#This shows the distributino of non-water type Pokemon near water
#Notice that the true bar is much lower here than on the water type graph.
#Also notice that there are a lot more true/false variables being calculated
#in this graph.