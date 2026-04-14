install.packages(c("sf","dplyr","readr","leaflet","shiny","tmap","classInt","scales","DT",
                   "osmdata","lubridate","jsonlite","googlesheets4","tidygeocoder","randomForest"))
# Optional (if you use GEE from R)
install.packages("rgee")

install.packages(c("tidyr","units"))

install.packages(c("ggplot2"))
library(sf)
library(ggplot2)
library(dplyr)

# Load the GeoJSON
# Load the GeoJSON
istanbul <- st_read("C:/Users/Speed/Documents/data/istanbul_polygons.geojson",
                    options = "ENCODING=UTF-8")

# Check the first few rows
head(istanbul)

# Check available columns
names(istanbul)


getwd()

ggplot(data = istanbul) +
  geom_sf(fill = "lightblue", color = "gray40") +
  ggtitle("Istanbul Districts / Neighborhoods") +
  theme_minimal()

ggplot(data = istanbul) +
  geom_sf(aes(fill = INDEX_YASAM_KALITESI), color = NA) +
  scale_fill_viridis_c(option = "plasma") +
  ggtitle("Istanbul Life Quality Index by Neighborhood") +
  theme_minimal()

library(sf); library(dplyr); library(readr); library(ggplot2)
library(leaflet); library(osmdata); library(tmap); library(classInt)
library(scales); library(tidyr); library(units)

cat("Working dir:", getwd(), "\n")

# Load libraries
library(sf)
library(dplyr)
library(readr)
library(ggplot2)

# Load libraries
library(sf)
library(dplyr)
library(readr)
library(ggplot2)

# Load your GEE datasets (adjust file paths if needed)
library(readxl)
aod <- read_excel("C:/Users/Speed/Documents/data/Istanbul_AOD.xlsx")
lst <- read_excel("C:/Users/Speed/Documents/data/Istanbul_LST.xlsx")
ndvi <- read_excel("C:/Users/Speed/Documents/data/Istanbul_NDVI.xlsx")
precip <- read_excel("C:/Users/Speed/Documents/data/Istanbul_Precipitation.xlsx")

# Check structure
glimpse(aod)
glimpse(lst)
glimpse(ndvi)
glimpse(precip)

library(sf)
library(dplyr)
library(jsonlite)

# Function to safely convert GeoJSON geometry to sf
convert_to_sf <- function(df, value_col, geo_col = ".geo") {
  df <- df %>% mutate(geometry = st_as_sfc(df[[geo_col]], GeoJSON = TRUE))
  df_sf <- st_sf(df, crs = 4326)
  df_sf <- df_sf %>% select(ILCE_ADI, MAHALLE_AD, all_of(value_col), geometry)
  return(df_sf)
}

# Apply the function for each dataset
aod_sf <- convert_to_sf(aod, "mean") %>% rename(AOD = mean)
lst_sf <- convert_to_sf(lst, "mean") %>% rename(LST = mean)
ndvi_sf <- convert_to_sf(ndvi, "mean") %>% rename(NDVI = mean)
precip_sf <- convert_to_sf(precip, "sum") %>% rename(Precip = sum)

# Rename value columns for clarity
aod_sf <- aod_sf %>% rename(AOD = mean)
lst_sf <- lst_sf %>% rename(LST = mean)
ndvi_sf <- ndvi_sf %>% rename(NDVI = mean)
precip_sf <- precip_sf %>% rename(Precip = sum)

# Check one
print(aod_sf)

# Merge step by step
env_data <- aod_sf %>%
  left_join(lst_sf %>% st_drop_geometry(), by = c("ILCE_ADI", "MAHALLE_AD")) %>%
  left_join(ndvi_sf %>% st_drop_geometry(), by = c("ILCE_ADI", "MAHALLE_AD")) %>%
  left_join(precip_sf %>% st_drop_geometry(), by = c("ILCE_ADI", "MAHALLE_AD"))
# Save your processed dataset
saveRDS(env_data, "C:/Users/Speed/Documents/data/env_data_ready.rds")

# Just to confirm it worked:
file.exists("C:/Users/Speed/Documents/data/env_data_ready.rds")

print(env_data)
summary(env_data)
plot(st_geometry(env_data))

library(ggplot2)

ggplot(env_data) +
  geom_sf(aes(fill = NDVI), color = NA) +
  scale_fill_viridis_c(option = "YlGn", na.value = "grey90") +
  labs(title = "NDVI Across Istanbul Neighborhoods",
       fill = "NDVI Index") +
  theme_minimal()


normalize <- function(x, invert = FALSE){
  xnum <- as.numeric(x)
  r <- range(xnum, na.rm=TRUE)
  if(r[1]==r[2]) z <- rep(0, length(xnum)) else z <- (xnum - r[1])/(r[2]-r[1])
  if(invert) z <- 1 - z
  z
}


# Ensure 'normalize' function is already defined (you have it)
env_data <- env_data %>%
  mutate(
    heat_s  = normalize(LST),                     # higher LST => higher risk
    air_s   = normalize(AOD),                     # higher AOD => higher risk
    flood_s = normalize(Precip),                  # higher precipitation => higher risk
    green_s = normalize(NDVI, invert = TRUE),     # low NDVI => higher risk
    CVI_equal = rowMeans(cbind(heat_s, air_s, flood_s, green_s), na.rm = TRUE),
    CVI_cat   = cut(CVI_equal,
                    breaks = c(-Inf, 0.33, 0.66, Inf),
                    labels = c("Green", "Yellow", "Red"))
  )




# Fit a quadratic model for LST based on NDVI
lm_fit <- lm(LST ~ NDVI + I(NDVI^2), data = env_data)
summary(lm_fit)

# Function to simulate NDVI increase and its effect on LST and CVI
simulate_ndvi_increase <- function(df, ilce, mahalle, ndvi_delta){
  
  b <- coef(lm_fit)
  
  # Get old NDVI value for the selected neighborhood
  old_ndvi <- df$NDVI[df$ILCE_ADI == ilce & df$MAHALLE_AD == mahalle]
  new_ndvi <- old_ndvi + ndvi_delta
  
  # Predict new LST using the model
  new_LST <- predict(lm_fit, newdata = data.frame(NDVI = new_ndvi))
  
  # Copy the data and update LST
  df2 <- df
  df2$LST[df2$ILCE_ADI == ilce & df2$MAHALLE_AD == mahalle] <- new_LST
  
  # Recompute normalized heat
  df2 <- df2 %>%
    mutate(heat_s = normalize(LST),
           CVI_equal = rowMeans(cbind(heat_s, air_s, flood_s, green_s), na.rm = TRUE))
  
  # Return the updated values for the selected neighborhood
  df2 %>%
    filter(ILCE_ADI == ilce & MAHALLE_AD == mahalle) %>%
    select(ILCE_ADI, MAHALLE_AD, NDVI, LST, heat_s, CVI_equal)
}

# Example: simulate NDVI increase of 0.1 in Kadikoy / Fener
simulate_ndvi_increase(env_data, ilce = "Kadikoy", mahalle = "Fener", ndvi_delta = 0.1)







