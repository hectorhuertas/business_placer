# Business Placer

Author: Hector Huertas

[Live on Heroku](https://business-placer.herokuapp.com/)

## Overview

Business Placer is a city analyst that finds the best spots in a city to open a new small business.

It combines population and existing businesses data to pick the 10 neighborhoods with lower saturation. For the most convenient neighborhoods, it shows the geographic influence of the existing businesses, so the user has the best information to make a decision.

## Screenshot

![Screenshot](/app/assets/images/business_placer.png)

## Instructions

  1. Enter a place and a location (* Currently Denver is the only city with population data).

  2. If the search was never done, an instructions page is shown while the server does all the calculations.

  3. After the calculations are done (about a minute or two), repeating the same search will show the results instead of the instructions page.

  4. The search result will show the 10 neighborhoods with lower amount of businesses of the searched type per capita.

  5. Clicking on any of those neighborhoods will show the geographical analysis of the neighborhood. The heatmap shows the influence of existing businesses in the area, so ideally the business should be located in a spot with very little or no heat at all.

## TO DO

  * Improve the interface so the user can use the website without referring to these instructions.

## Special code features

### API
  * Yelp's API provides information about existing businesses.
  * Google Map's API provides information about all the locations and provides the libraries to render the map and heatmaps.

### Testing
  * VCR to ease testing involving external APIs.

### Background worker
  * All calculations are done asynchronously in a Sidekiq background worker.

### Redis
  * Using Redis as cache store to allow the background worker to share the cache with the standard server dyno.
  * Also using Redis to store the background worker information.

### Authentication
  * OAuth Google authentication.

### Population
  * Population at Denver is provided by Denver Open Data Catalog.
  * Other cities population will be added in the future.
