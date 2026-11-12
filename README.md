# Census API dataset tracker

This project tracks the dataset endpoints available in the U.S. Census Bureau APIs. There are no publicly available changelogs or regular announcements of added or removed endpoints. This scraper aims to fill that gap.

[See the tracker](https://www.hrecht.com/census-api-datasets/)

[Follow updates on Bluesky](https://bsky.app/profile/censusapitracker.bsky.social)

## How it works

[scripts/update-metadata.R](scripts/update-metadata.R) gets the Census Bureau's dataset [metadata json](https://api.census.gov/data.json) using the `R censusapi` package [listCensusApis()](https://www.hrecht.com/censusapi/reference/listCensusApis.html) function. This function selectively keeps and formats important metadata fields and ignores generic fields.

The script then checks to see what type of change has occured and outputs information accordingly.

Data change types:

- `Major`: datasets added and/or removed
- `Minor`: changes to key metadata fields, like dataset names or descriptions, but no dataset additions or removals
- `None`: no changes to key metadata fields

All scraper runs update the update time displayed on the web page. Results are logged in [data/update-log.csv](data/update-log.csv).

On `major` data changes, endoint changes are saved out to the web page `src/`. On both `major` and `minor` changes the full metadata json is saved to [data/data.json](data/data.json) for posterity.

A [Github action](.github/workflows/update-data-json.yml) runs the scraper, commits changes, and rebuilds the web page. It posts to Bluesky if there are any `major` data changes.

## Tools

Disclaimer: This project uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau.

The web page is built using [Svelte](https://svelte.dev/) and SvelteKit. The vertical bar chart uses [Layer Cake](https://layercake.graphics/). The robots.txt file is from [ai-robots-txt](https://github.com/ai-robots-txt/ai.robots.txt). The Bluesky icon is from [icons8](https://icons8.com/).
