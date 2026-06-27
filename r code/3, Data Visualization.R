# Only interested in Sold
AUCTION_SOLD <- subset(AUCTION_MERGED, Note == 'Sold')
View(AUCTION_SOLD)

# Aggregate data
# Some of these variables are not needed
library(dplyr)
AGGR_MELB <- AUCTION_SOLD %>%
  group_by(Suburb, Property_Type, Distance_km, lat, lon) %>%
  summarise(N = n(),
            Total_Sold = sum(Price, na.rm = TRUE),
            Min_Price = min(Price, na.rm = TRUE),
            Max_Price = max(Price, na.rm = TRUE),
            Median_Price = median(Price, na.rm = TRUE),
            Null_Price = sum(is.na(Price)))  %>%
  arrange(desc(N))

# Best to check if all property types are included
# In this demo, it is not
table(AGGR_MELB$Property_Type)
# House    Studio Townhouse      Unit     Villa 
# 355         1        69       126         1 

# Create a map
# I somehow feel that there is a better way of doing this
HOUSE_C <- '#16db65'
TOWNHOUSE_C <- '#5bc0eb'
UNIT_C <- '#ff5d73'

library(leaflet)
leaflet(AGGR_MELB) %>% 
  setView(lng = 144.9650779, lat = -37.8144855, zoom = 10) %>%
  addProviderTiles("Stamen.Toner", group = "Map A") %>% 
  addProviderTiles("CartoDB.Positron", group = "Map B") %>%
  addCircleMarkers(lng=subset(AGGR_MELB, Property_Type=='House')$lon,
                   lat=subset(AGGR_MELB, Property_Type=='House')$lat,
                   color = HOUSE_C, 
                   weight = 1, 
                   #radius = 5,
                   radius = subset(AGGR_MELB, Property_Type=='House')$N,
                   opacity = 0.8, #outer circle
                   fillColor = HOUSE_C,
                   fillOpacity = 1, #inner circle
                   popup=paste0('Median Price', ' ', as.character(subset(AGGR_MELB, Property_Type=='House')$Median_Price), " "),
                   label=paste0(subset(AGGR_MELB, Property_Type=='House')$N, ' sold in ', 
                                subset(AGGR_MELB, Property_Type=='House')$Suburb, ""), group = "House") %>%

  addCircleMarkers(lng=subset(AGGR_MELB, Property_Type=='Townhouse')$lon,
                   lat=subset(AGGR_MELB, Property_Type=='Townhouse')$lat,
                   color = TOWNHOUSE_C, 
                   weight = 1, 
                   #radius = 5,
                   radius = subset(AGGR_MELB, Property_Type=='Townhouse')$N,
                   opacity = 0.8, #outer circle
                   fillColor = TOWNHOUSE_C,
                   fillOpacity = 1, #inner circle
                   popup=paste0('Median Price', ' ', as.character(subset(AGGR_MELB, Property_Type=='Townhouse')$Median_Price), " "),
                   label=paste0(subset(AGGR_MELB, Property_Type=='Townhouse')$N, ' sold in ', 
                                subset(AGGR_MELB, Property_Type=='Townhouse')$Suburb, ""), group = "Townhouse") %>%
  
  addCircleMarkers(lng=subset(AGGR_MELB, Property_Type=='Unit')$lon,
                   lat=subset(AGGR_MELB, Property_Type=='Unit')$lat,
                   color = UNIT_C, 
                   weight = 1, 
                   #radius = 5,
                   radius = subset(AGGR_MELB, Property_Type=='Unit')$N,
                   opacity = 0.8, #outer circle
                   fillColor = UNIT_C,
                   fillOpacity = 1, #inner circle
                   popup=paste0('Median Price', ' ', as.character(subset(AGGR_MELB, Property_Type=='Unit')$Median_Price), " "),
                   label=paste0(subset(AGGR_MELB, Property_Type=='Unit')$N, ' sold in ', 
                                subset(AGGR_MELB, Property_Type=='Unit')$Suburb, ""), group = "Unit") %>%
  
  addLayersControl(
    position = 'topright',
    baseGroups = c("Map A", "Map B"),
    overlayGroups = c("House", "Townhouse", "Unit"),
    options = layersControlOptions(collapsed = TRUE, autoZIndex = TRUE)
  )   %>%
    #Add legend
    addLegend(title = "Property Type", 
              position = "bottomright", 
              colors = c(HOUSE_C, TOWNHOUSE_C, UNIT_C), 
              labels = c("House", "Townhouse", "Unit"), opacity = 1)
  
