# Author: Bryan Carlson
# Contact: bryan.carlson@ars.usda.gov
# Purpose: Remove projection from georef points, clean data, create json document for import into CosmosDB

library(tidyverse)
library(sf)
library(tmap)
library(jsonlite)

# Load data
georef <- st_read("Input/All_CookEast/All_CookEast.shp")

# Check data
georef
tm_shape(georef) +
  tm_dots()

# Remove projection and clean up data
georefClean <- georef %>% 
  st_transform(crs = 4326) %>% 
  select("ID2", "COLUMN", "ROW2", "STRIP", "FIELD") %>% 
  rename(
    "ID2" = "ID2",
    "Column" = "COLUMN",
    "Row2" = "ROW2",
    "Strip" = "STRIP",
    "Field" = "FIELD") %>% 
  arrange(ID2)

# Write as geojson
dateToday <- format(Sys.Date(), "%y%m%d")
outPath <- paste("Output/CookEastGeoreferencePoints_", 
                 dateToday, 
                 ".geojson",
                 sep = "")
st_write(georefClean, outPath)

# TODO: Split into separate docs per point, add additional info, create EtlEvent