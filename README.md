# Melbourne Auction Results

Scraping, cleaning, and visualising Melbourne property auction results — with geocoding, CBD distance calculations, and an interactive map.

## Problem

Melbourne's property auction market moves fast. Getting a clear picture of what's selling, where, and at what price requires pulling data from scattered sources and making sense of it. This project automates that: scrape auction results, clean the messy price formats, enrich with location data, and visualise it all on an interactive map.

## Approach

Three-stage pipeline in R:

| # | Script | What It Does |
|---|--------|-------------|
| 1 | `1, Data Extraction Code.R` | Web scraping with `rvest` — extracts suburb, address, price, property type, bedrooms, agent from auction listings |
| 2 | `2, Data Cleansing.R` | Price parsing ($870k → 870000), handling "Passed In" / "Price withheld", geocoding suburbs, calculating CBD distance |
| 3 | `3, Data Visualization.R` | Aggregates by suburb, builds interactive Leaflet map with property type layers |

## Results

The final output is an interactive map of Melbourne showing:
- **Circle size** — number of properties sold in each suburb
- **Colour** — property type (green = House, blue = Townhouse, red = Unit)
- **Popups** — median sale price on click
- **Layer toggle** — filter by House / Townhouse / Unit

![Map Preview](https://github.com/wsamuelw/proj-auction-results/blob/main/image/datavis.PNG)

## Data Pipeline

```
Raw HTML → rvest scraping → price parsing → geocoding → CBD distance → aggregation → Leaflet map
```

### Price Parsing

Auction results come in inconsistent formats:

| Raw | Parsed |
|-----|--------|
| `$870k` | 870,000 |
| `$1.27m` | 1,270,000 |
| `Passed In` | 0 (flagged) |
| `Price withheld` | 0 (flagged) |

### Geocoding

Each suburb is geocoded via Google Maps API and assigned:
- Latitude/longitude for map placement
- Driving distance from Melbourne CBD (-37.814, 144.965)

## Setup

```bash
git clone https://github.com/wsamuelw/proj-auction-results.git
cd proj-auction-results
```

```r
install.packages(c("rvest", "dplyr", "ggmap", "leaflet", "sqldf", "zoo", "gmapsdistance"))
source("R/1, Data Extraction Code.R")
source("R/2, Data Cleansing.R")
source("R/3, Data Visualization.R")
```

## Data

Sourced from Melbourne auction listing websites. Each row represents one auction result:

| Field | Description |
|-------|------------|
| Address | Property address |
| Suburb | Melbourne suburb |
| Property_Type | House, Townhouse, Unit, Studio, Villa |
| Bedroom | Number of bedrooms |
| Sold_Method | Auction / Private Exchange |
| Agent | Selling agent |
| Price | Sale price (or Passed In / Price withheld) |
| Distance_km | Distance from Melbourne CBD |
| lat/lon | Geocoded coordinates |

**Note:** Data quality varies — some prices are withheld, some addresses are too new for geocoding.

## Tech Stack

- **rvest** — HTML scraping
- **ggmap / gmapsdistance** — geocoding and distance calculation
- **dplyr** — data aggregation
- **leaflet** — interactive map visualisation
- **sqldf** — SQL-style queries on data frames
- **zoo** — last-observation-carried-forward for suburb filling

## Interactive Map

The Leaflet map includes:
- Toggle between Stamen Toner and CartoDB Positron basemaps
- Filter by property type (House / Townhouse / Unit)
- Click any circle to see median price
- Circle radius scales with number of sales

[View the interactive map on RPubs](http://rpubs.com/samuel_wong_/Melbourne-auction-results-29-04-17)

## License

MIT
