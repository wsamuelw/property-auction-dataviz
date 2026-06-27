# Melbourne Property Auction Data Visualisation

> Scrape, clean, and visualise Melbourne property auction results — with geocoding, CBD distance calculations, and an interactive Leaflet map.

<p align="center">
  <img src="https://raw.githubusercontent.com/wsamuelw/property-auction-dataviz/master/image/dataviz.PNG" width="800" alt="Melbourne auction map visualisation" />
</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![R](https://img.shields.io/badge/R-4.0+-276DC3.svg)](https://www.r-project.org/)

---

## Features

- **Automated scraping** — extracts auction results from Melbourne listing sites
- **Price parsing** — converts messy formats (`$870k`, `$1.27m`, "Passed In") to clean numbers
- **Geocoding** — maps suburbs to lat/lon coordinates via Google Maps API
- **CBD distance** — calculates driving distance from Melbourne CBD for each suburb
- **Interactive map** — Leaflet visualisation with property type layers, popups, and filters

---

## Demo

**[View the interactive map on RPubs →](http://rpubs.com/samuel_wong_/Melbourne-auction-results-29-04-17)**

The map shows:
- **Circle size** — number of properties sold in each suburb
- **Colour** — property type (green = House, blue = Townhouse, red = Unit)
- **Popups** — median sale price on click
- **Layer toggle** — filter by House / Townhouse / Unit

---

## Pipeline

```
Raw HTML → rvest scraping → price parsing → geocoding → CBD distance → aggregation → Leaflet map
```

| Stage | Script | What It Does |
|-------|--------|-------------|
| 1 | `r code/1, Data Extraction Code.R` | Scrapes suburb, address, price, property type, bedrooms, agent |
| 2 | `r code/2, Data Cleansing.R` | Parses prices, handles missing data, geocodes suburbs, calculates CBD distance |
| 3 | `r code/3, Data Visualization.R` | Aggregates by suburb, builds interactive Leaflet map |

---

## Quick Start

### Prerequisites

- [R](https://www.r-project.org/) 4.0 or higher
- [Google Maps API key](https://developers.google.com/maps/documentation/geocoding/get-api-key) (for geocoding)

### Installation

```bash
git clone https://github.com/wsamuelw/property-auction-dataviz.git
cd property-auction-dataviz
```

```r
# Install dependencies
source("setup.R")

# Or install manually
install.packages(c("rvest", "dplyr", "ggmap", "leaflet", "sqldf", "zoo", "gmapsdistance"))
```

### Run the Pipeline

```r
source("r code/1, Data Extraction Code.R")  # Scrape data
source("r code/2, Data Cleansing.R")         # Clean and geocode
source("r code/3, Data Visualization.R")     # Build map
```

---

## Data Schema

Each row represents one auction result:

| Field | Description |
|-------|------------|
| `Address` | Property address |
| `Suburb` | Melbourne suburb |
| `Property_Type` | House, Townhouse, Unit, Studio, Villa |
| `Bedroom` | Number of bedrooms |
| `Sold_Method` | Auction / Private Exchange |
| `Agent` | Selling agent |
| `Price` | Sale price (or Passed In / Price withheld) |
| `Distance_km` | Distance from Melbourne CBD |
| `lat/lon` | Geocoded coordinates |

**Note:** Data quality varies — some prices are withheld, some addresses are too new for geocoding.

---

## Tech Stack

| Package | Purpose |
|---------|---------|
| [rvest](https://rvest.tidyverse.org/) | HTML scraping |
| [ggmap](https://github.com/dkahle/ggmap) | Geocoding via Google Maps API |
| [gmapsdistance](https://github.com/rodazuero/gmapsdistance) | Driving distance calculations |
| [dplyr](https://dplyr.tidyverse.org/) | Data aggregation |
| [leaflet](https://rstudio.github.io/leaflet/) | Interactive map visualisation |
| [sqldf](https://cran.r-project.org/web/packages/sqldf/index.html) | SQL queries on data frames |
| [zoo](https://cran.r-project.org/web/packages/zoo/index.html) | Last-observation-carried-forward |

---

## License

[MIT](LICENSE)
