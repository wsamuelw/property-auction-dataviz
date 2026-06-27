# Data Cleansing
# Create new variable to store texts
AUCTION_MEL$Note <- 
ifelse(AUCTION_MEL$Price =='Passed In', "Passed In", 
ifelse(AUCTION_MEL$Price =='Price withheld', "Price withheld",
ifelse(AUCTION_MEL$Price =='Withdrawn', "Withdrawn","Sold")))

# Replace texts to zero
AUCTION_MEL$Price <- gsub("Passed In|Price withheld|Withdrawn", "0", AUCTION_MEL$Price)

# Remove $
AUCTION_MEL$Price <- gsub("\\$", "", AUCTION_MEL$Price)

# Create new variable Unit to do the math
AUCTION_MEL$Unit <- 
ifelse(grepl("k",AUCTION_MEL$Price), 1000,
ifelse(grepl("m",AUCTION_MEL$Price), 1000000, 0))

# Remove k m 
AUCTION_MEL$Price <- gsub("k|m", "", AUCTION_MEL$Price)

# Format as numeric
AUCTION_MEL$Price <- as.numeric(AUCTION_MEL$Price)

# Do the math
AUCTION_MEL$Price <- AUCTION_MEL$Price * AUCTION_MEL$Unit

# Remove Unit
AUCTION_MEL$Unit <- NULL

# Create full address for lat lon
AUCTION_MEL$Full_Suburb <- paste(AUCTION_MEL$Suburb, ', Victoria, Australia', sep = "")
AUCTION_MEL$Full_Address <- paste(AUCTION_MEL$Address, AUCTION_MEL$Suburb, 'VIC Australia', sep = " ")
AUCTION_MEL$Date2 <- as.Date('2017-05-21')

# Get a unique list of full suburbs
# 1, Get the lat lon for each suburb (Some of these addresses are too new for Google Map)
# 2, Get the distance between CBD (Using Google API)
library(sqldf)
UNIQUE <- sqldf('select distinct Full_Suburb as Full_Suburb from AUCTION_MEL')
View(UNIQUE)

# Get lat lon for each suburb
library(ggmap)
API <- 'Enter Your API Key Here' -- It works without an API key too!
UNIQUE <- mutate_geocode(UNIQUE, Full_Suburb)
names(UNIQUE)
# [1] "Full_Suburb" "lon"         "lat"        

# Calculate distance from CBD
library(gmapsdistance)
set.api.key("Enter Your API Key Here")

# Format lat lon
UNIQUE$Origin <- paste0("-37.8144855", "+", "144.9650779") # Melbourne CBD
UNIQUE$Destination <- paste0(UNIQUE$lat, "+" ,UNIQUE$lon)
DISTANCE <- gmapsdistance(UNIQUE$Origin[1], UNIQUE$Destination, mode="driving", shape="long")

library(dplyr)
DISTANCE_DF <- select(as.data.frame(DISTANCE), Destination = Status.de, Drive_Time = Time.Time, Distance_m = Distance.Distance)
DISTANCE_DF$Distance_km <- ceiling(round(DISTANCE_DF$Distance_m / 1000, 1))

# Create a referrence table
SUBURB_REF <- merge(x = UNIQUE, y = DISTANCE_DF, by = "Destination", all = TRUE)
View(SUBURB_REF)

# Merge with the main dataset
AUCTION_MERGED <- merge(x = AUCTION_MEL, y = SUBURB_REF, by = "Full_Suburb", all = T)

names(AUCTION_MERGED)
# [1] "Full_Suburb"   "Address"       "Suburb"        "Property_Type" "Bedroom"       "Sold_Method"   "Agent"         "Price"         "Note"         
# [10] "Full_Address"  "Date"          "Destination"   "lon"           "lat"           "Origin"        "Drive_Time"    "Distance_m"    "Distance_km"  

# View the data
View(AUCTION_MERGED)

# I know the data can have duplicate rows
# I am going to skip this part for you to figure out how to remove dups
