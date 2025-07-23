# Census API dataset tracker

This project tracks the dataset endpoints available in the U.S. Census Bureau APIs. There are no publicly available changelogs or regular announcements of added or removed endpoints. This daily scraper aims to fill that gap.

The scraper uses the censusapi R package's [listCensusApis()](https://www.hrecht.com/censusapi/reference/listCensusApis.html) function, with output saved in [data/endpoints.csv](data/endpoints.csv). If there are any changes to `endpoints.csv`, the full [dataset metadata json](https://api.census.gov/data.json) is also saved to [data/data.json](data/data.json). Endpoint additions and removals are also saved to [data/endpoint-changes.csv](data/endpoint-changes.csv).