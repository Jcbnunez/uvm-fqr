#### Set up your instance of R in the VACC as follows
# module load Rgeospatial/4.4.0-2024-05-09; module load cmake/3.28.3; module load rstudio

#### First install new packages
install.packages("nasapower")
install.packages("FactoMineR")
install.packages("factoextra")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("rnaturalearthhires")
install.packages("ggOceanMaps")


#### now load these packages
library(rnaturalearth)
library(rnaturalearthdata)
library(nasapower)
library(tidyverse)
library(FactoMineR)
library(factoextra)
library(ggOceanMaps)

#### Part 1: Download NASA data
### lonlat = c(-85.693267, 10.944167)

ex.data.dat <- get_power(
  community = "ag",
  lonlat = c(-85.693267, 10.944167),
  pars = c("RH2M", "T2M", "PRECTOTCORR"),
  dates = c(paste(2015, "-01-01", sep=""), 
            paste(2024, "-07-05", sep="")),
  temporal_api = "hourly", 
  time_standard="UTC"
) 

### Explore data
ex.data.dat %>% head

### Plot data
ex.data.dat %>%
  mutate(date = as.Date(paste(YEAR,MO,DY, sep ="-"))) ->
  ex.data.dat.Date

###
ex.data.dat.Date %>%
  ggplot(aes(
    x=date,
    y=T2M
  )) + geom_point() + 
  geom_smooth(span = 1/20)

### Temperature
ex.data.dat.Date %>%
  filter(YEAR >= 2024 & MO >= 6) %>%
  ggplot(aes(
    x=date,
    y=T2M
  )) + geom_point() + 
  geom_smooth(span = 1/20) +
  ggtitle("Temp vs. Time")

### Temperature
ex.data.dat.Date %>%
  filter(YEAR >= 2024 & MO >= 6) %>%
  ggplot(aes(
    x=date,
    y=PRECTOTCORR
  )) + geom_point() + 
  geom_smooth(span = 1/20)  +
  ggtitle("Precip vs. Time")


### Correlation between variables
ex.data.dat.Date %>%
  filter(YEAR >= 2024 & MO >= 1) %>%
  select(T2M, RH2M, PRECTOTCORR) %>%
  PCA(graph = F) -> pca.transformation

pca.transformation

### How can we explore multiple variables
fviz_pca_var(pca.transformation, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)
####
#world <- map_data("world")
world <- ne_countries(scale = 110, returnclass = "sf") 

ggplot() +
  geom_sf(data = world, 
          color = "black", fill = "lightgray", linewidth = 0.1) +
  theme_classic() +
  ggtitle("World") ->
  world_plot
ggsave(world_plot, file = "world_plot.pdf", w= 8, h = 6)


###zoom - in
CR <- ne_countries(scale = 10, returnclass = "sf", continent = "North America") 

CR_map <- ggplot() +
  geom_sf(data = CR) +
  coord_sf(xlim = c(-87,-83), ylim = c(8,11)) +
  ggtitle("Pura Vida")
ggsave(CR_map, file = "CR_plot.pdf", w= 8, h = 6)

### deatils
if(!file.exists("maps/ne_10m_rivers_europe.shp")){
  ne_download(scale = 10, type = "rivers_lake_centerlines", category = "physical", 
              destdir = "maps/", load = FALSE) # major rivers
  ne_download(scale = 10, type = "lakes", category = "physical", 
              destdir = "maps/", load = FALSE) # major lakes
}

  rivers <- ne_load(scale = 10, type = "rivers_lake_centerlines", destdir = "maps", returnclass = "sf")
  lakes <- ne_load(scale = 10, type = "lakes", destdir = "maps", returnclass = "sf")
  
  CR_map <- ggplot() +
    geom_sf(data = CR) +
    geom_sf(data = rivers, colour = "blue", linewidth = 0.2) + 
    geom_sf(data = lakes, fill = "lightblue") + 
    coord_sf(xlim = c(-87,-83), ylim = c(8,11)) +
    ggtitle("Pura Vida") ->
    CR_map
  ggsave(CR_map, file = "CR_plot.pdf", w= 8, h = 6)
  
### Super Zoom in to guanvaste  
  CR_map <- ggplot() +
    geom_sf(data = CR) +
    geom_sf(data = rivers, colour = "blue", linewidth = 0.2) + 
    geom_sf(data = lakes, fill = "lightblue") + 
    coord_sf(xlim = c(-85.693267-1,-85.693267+1), 
             ylim = c(10.944167-1, 10.944167+1), expand = FALSE) + 
    theme(panel.grid.major = element_line(color = gray(.5), 
                                          linetype = "dashed", 
                                          linewidth = 0.2), 
          panel.background = element_rect(fill = "aliceblue")) +
    ggtitle("Pura Vida + IRES") ->
    CR_mapIRES
  ggsave(CR_mapIRES, file = "CR_mapIRES.pdf", w= 8, h = 6)
  

###zoom - in --- even more

### oceans using ggOceanMaps
basemap(limits = c(-85.693267-1,-85.693267+1, 10.944167-1, 10.944167+1),
        bathymetry = TRUE, bathy.style = "rcb")->
  CR_map_ocean
ggsave(CR_map_ocean, file = "CR_map_ocean.pdf", w= 8, h = 6)

### oceans using ggOceanMaps + plus data
basemap(limits = c(-85.693267-1,-85.693267+1, 10.944167-1, 10.944167+1),
        bathymetry = TRUE, bathy.style = "rcb") + 
  geom_point(aes(x=-85.693267, y =10.944167), size = 5, color = "red")->
  CR_map_ocean_point
ggsave(CR_map_ocean_point, file = "CR_map_ocean_point.pdf", w= 8, h = 6)


### how to plot spatial data into maps!!
### STEP 1 simulate some data

data.frame(
  long=runif(50, -85.693267-1,-85.693267+1),
  lat=runif(50, 10.944167-1, 10.944167+1),
  number_of_seagulls = rpois(100, 2 )
    ) -> seagull_sightings


basemap(limits = c(-85.693267-1,-85.693267+1, 10.944167-1, 10.944167+1),
        bathymetry = TRUE, bathy.style = "rcb") + 
  geom_point(data =seagull_sightings,
             aes(x=long, y =lat, color = number_of_seagulls),
             size = 5) + 
  scale_color_viridis_b()->
  CR_map_ocean_point_gulls
ggsave(CR_map_ocean_point_gulls, 
       file = "CR_map_ocean_point_gulls.pdf", w= 8, h = 6)






