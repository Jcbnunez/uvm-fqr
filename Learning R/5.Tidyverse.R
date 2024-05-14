#Tidyverse

library(tidyverse)

iris
iris %>% head()
iris$Species

iris %>% filter(Species == "setosa")
iris %>% filter(Petal.Width > 1.6)

iris$Petal.Width %>% min()
iris %>% filter(Petal.Width > 1.6) %>% .$Petal.Width %>% min()

## Grouping

iris %>%
  group_by(Species) %>%
  summarise(avPetal = mean(Petal.Width))


iris %>%
  group_by(Species) %>%
  summarise(avPetal = mean(Petal.Width),
            sdPetal = sd(Petal.Width),
            minPetal = min(Petal.Width)
            )

# mutate
iris %>%
  mutate(mynewvar = Petal.Width+10)


iris %>%
  mutate(classifier = 
           case_when(Petal.Width < 1.1 ~ "small", 
                     TRUE ~ "big")
           )

iris %>%
  mutate(classifier = 
           case_when(Petal.Width < 1.1 ~ "small", 
                     TRUE ~ "big")
  ) %>%
  group_by(Species, classifier) %>%
  summarise(classi_sp = n())
