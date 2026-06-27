library(rvest)
#library(help = rvest)

url <- 'Paste the URL here'
webpage <- read_html(url)

# Suburb
suburb_node <- html_nodes(webpage,'.suburb-listings__heading')
Suburb <- html_text(suburb_node)
head(Suburb)
length(Suburb)
suburb_df <- data.frame(Suburb)

# Address
address_node <- html_nodes(webpage,'.auction-details__address , .suburb-listings__heading')
Address <- html_text(address_node)
head(Address)
length(Address)
address_df <- data.frame(Address)

# Price
price_html <- html_nodes(webpage,'.auction-details__price')
Price <- html_text(price_html)
head(Price)
length(Price)
price_df <- data.frame(Price)

# Sold Method
sold_method_html <- html_nodes(webpage,'.auction-details__price-label')
Sold_Method <- html_text(sold_method_html)
head(Sold_Method)
length(Sold_Method)
sold_method_df <- data.frame(Sold_Method)

# Property Type
property_type_html <- html_nodes(webpage,'.auction-details__property-type')
Property_Type <- html_text(property_type_html)
head(Property_Type)
length(Property_Type)
property_type_df <- data.frame(Property_Type)

# Bedroom
bedroom_html <- html_nodes(webpage,'.auction-details__bedroom')
Bedroom <- html_text(bedroom_html)
head(Bedroom)
length(Bedroom)
bedroom_df <- data.frame(Bedroom)

# Agent
agent_html <- html_nodes(webpage,'.auction-details__agent')
Agent <- html_text(agent_html)
head(Agent)
length(Agent)
agent_df <- data.frame(Agent)

# Re-structure full address
address_df$Suburb <- suburb_df$Suburb[match(address_df$Address, suburb_df$Suburb)]

# This is more like a hack to populate the suburb for each address
# The idea is to populate the suburb above when current value is NULL
# Keep rows when both are not the same
library(zoo)
address_df$Suburb <- na.locf(address_df$Suburb)
address_df <- subset(address_df, as.character(Address) != as.character(Suburb))

# Merge all datasets
AUCTION_MEL <- data.frame(address_df, property_type_df, bedroom_df, sold_method_df, agent_df, price_df)

names(AUCTION_MEL)
# "Address"       "Suburb"        "Property_Type" "Bedroom"       "Sold_Method"   "Agent"         "Price"       

head(AUCTION_MEL)
# Address       Suburb Property_Type Bedroom      Sold_Method                   Agent  Price
# 2     6/205 Gipps St   ABBOTSFORD          Unit       2                  Biggin & Scott Richmond  $870k
# 3        67B Park St   ABBOTSFORD     Townhouse       3                       Beller Residential $1.27m
# 4    518/1 Acacia Pl   ABBOTSFORD          Unit       1 Private Exchange Biggin & Scott Richmond  $325k
# 5 411/8 Grosvenor St   ABBOTSFORD          Unit       2 Private Exchange   Jellis Craig Richmond  $705k
# 7     2/80 Hawker St AIRPORT WEST          Unit       2 Private Exchange    Barry Plant Essendon  $520k
# 8       83 Hawker St AIRPORT WEST         House       3 Private Exchange     Pennisi Real Estate  $939k

# I always like to view the data to get a feel
View(AUCTION_MEL)
