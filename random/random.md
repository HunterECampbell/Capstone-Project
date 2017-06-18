---
title: "random"
author: "Hunter Campbell"
date: "June 17, 2017"
output:
  html_document: default
  pdf_document: default
---

```{r echo = FALSE, message = FALSE}
library(ggplot2)
PokeGo_water2water <- read.csv(file = "C:/Users/hcnur_000/Desktop/Capstone Project/Capstone Project Data Wrangling/PokeGo_water2water.csv")
ggplot(PokeGo_water2water, aes(closeToWater, fill = closeToWater)) +
  geom_bar() +
  labs(x = "Close to Water", y = "Appearances of Water Type Pokemon",
       fill = "Close To Water")
```
