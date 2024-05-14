library(tidyverse)


iris %>% head()

iris %>%
  ggplot(
    aes(
      x=Sepal.Length,
      y=Petal.Length,
      color=Species,
      shape = Species
    )
  ) + geom_point()


iris %>%
  ggplot(
    aes(
      x=Sepal.Length,
      y=Petal.Length,
      color=Species,
      shape = Species
    )
  ) + geom_point() +
  facet_grid(~Species)

iris %>%
  ggplot(
    aes(
      x=Sepal.Length,
      y=Petal.Length,
      color=Species,
    )
  ) + geom_point() +
  geom_smooth(color = "black")
