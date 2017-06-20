library(ggplot2)
library(tidyr)
library(dplyr)
library(plyr)
library(plotly)

PokeGo_clean <- read.csv(file = "C:/Users/hcnur_000/Desktop/Capstone Project/Capstone Project Data Wrangling/PokeGo_clean.csv")
PokeGo_water2water <- read.csv(file = "C:/Users/hcnur_000/Desktop/Capstone Project/Capstone Project Data Wrangling/PokeGo_water2water.csv")
PokeGo_notwater2water <- read.csv(file = "C:/Users/hcnur_000/Desktop/Capstone Project/Capstone Project Data Wrangling/PokeGo_notwater2water.csv")
View(PokeGo_clean)
View(PokeGo_water2water)
View(PokeGo_notwater2water)

#A little data wrangling:
PokeGo_clean <- select(PokeGo_clean, -X)
PokeGo_water2water <- select(PokeGo_water2water, -X)
PokeGo_notwater2water <- select(PokeGo_notwater2water, -X)


#To use machine learning to find Pokemon rarity in PokemonGo, I used K-means
#because the sample size is huge.

#First I made new datasets:
cleanId <- select(PokeGo_clean, pokemonId)
waterId <- select(PokeGo_water2water, pokemonId)
notwaterId <- select(PokeGo_notwater2water, pokemonId)
View(cleanId)
View(waterId)
View(notwaterId)

#I turned them into a factor, because each Id represents a Pokemon.
cleanIdFactor <- as.factor(cleanId$pokemonId)
waterIdFactor <- as.factor(waterId$pokemonId)
notwaterIdFactor <- as.factor(notwaterId$pokemonId)

#I then counted the number of times each Pokemon is seen:
cleanId <- count(cleanIdFactor, 1)
waterId <- count(waterIdFactor, 1)
notwaterId <- count(notwaterIdFactor, 1)

#and arranged the datasets by the frequency (this way k-means will group it
#according to the rarity/frequency instead of the Id).
cleanId <- arrange(cleanId, freq)
waterId <- arrange(waterId, freq)
notwaterId <- arrange(notwaterId, freq)
#I then changed the x columns name back to PokemonId, because count deleted the 
#old PokemonId column and replaced it with a column named x.
colnames(cleanId)[1] <- "pokemonId"
colnames(waterId)[1] <- "pokemonId"
colnames(notwaterId)[1] <- "pokemonId"

write.csv(cleanId, "C://Users//hcnur_000//Desktop//cleanId.csv")
write.csv(waterId, "C://Users//hcnur_000//Desktop//waterId.csv")
write.csv(notwaterId, "C://Users//hcnur_000//Desktop//notwaterId.csv")


#Lets start the K-means clusters:
k <- 4  #I chose 4 because I want to sort the rarity into 4 categories
set.seed(1)

#Making the clusters for each dataset:
cleanIdKMC <- kmeans(cleanId$freq, centers = k)
waterIdKMC <- kmeans(waterId$freq, centers = k)
notwaterIdKMC <- kmeans(notwaterId$freq, centers = k)
#Checking the structure of each dataset:
str(cleanIdKMC)
str(waterIdKMC)
str(notwaterIdKMC)


#Plots the rarity:
##All Pokemon:
cleanRarity <- ggplot(cleanId, aes(pokemonId, freq, col = factor(cleanIdKMC$cluster), alpha = .5)) +
  geom_point() +
  labs(x = "All Pokemon Id's", y = "Frequency") +
  scale_color_manual(values = c("#800080", "#006622", "#e68a00", "#ff0000"),
                     name = "Rarity",
                     breaks = c(4, 3, 2, 1),
                     labels = c("Very Common", "Common", "Rare", "Very Rare"),
                     guide = F) +
  scale_alpha(guide = F) +
  theme(axis.text.x = element_blank())
cleanRarity
#Now lets also plot an interactive graph so that we can easily
#see what each point is:
ggplotly(cleanRarity) %>%
  layout(showlegend = F)

##Water Type Pokemon:
waterRarity <- ggplot(waterId, aes(pokemonId, freq, col = factor(waterIdKMC$cluster), alpha = .5)) +
  geom_point() +
  labs(x = "Water Type Pokemon Id's", y = "Frequency") +
  scale_color_manual(values = c("#800080", "#e68a00", "#ff0000", "#006622"),
                     name = "Rarity",
                     breaks = c(4, 3, 2, 1),
                     labels = c("Very Common", "Common", "Rare", "Very Rare"),
                     guide = F) +
  scale_alpha(guide = F) +
  theme(axis.text.x = element_blank())
waterRarity

ggplotly(waterRarity) %>%
  layout(showlegend = F)

##Non-water Type Pokemon:
notwaterRarity <- ggplot(notwaterId, aes(pokemonId, freq, col = factor(notwaterIdKMC$cluster), alpha = .5)) +
  geom_point() +
  labs(x = "Non-water Type Pokemon Id's", y = "Frequency") +
  scale_color_manual(values = c("#800080", "#006622", "#e68a00", "#ff0000"),
                     name = "Rarity",
                     breaks = c(4, 3, 2, 1),
                     labels = c("Very Common", "Common", "Rare", "Very Rare"),
                     guide = F) +
  scale_alpha(guide = F) +
  theme(axis.text.x = element_blank())
notwaterRarity

ggplotly(notwaterRarity) %>%
  layout(showlegend = F)
