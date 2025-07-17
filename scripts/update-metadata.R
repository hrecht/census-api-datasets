library(censusapi)

# Read in old metadata
endpoints_old <- read.csv("data/endpoints.csv")
endpoints_old[endpoints_old == ""] <- NA 

# Get metadata
endpoints <- listCensusApis()

# Sort (using base R to avoid extra dependencies)
endpoints <- endpoints[order(endpoints$vintage, endpoints$name, decreasing = T),]
row.names(endpoints) <- NULL

# Is there any difference?
is_identical <- identical(endpoints_old, endpoints)
print("Are the old and new endpoints metadata identical?")
print(is_identical)

if (is_identical) {
	print("Nothing to change")
	
	system('echo "UPDATED_DATA=false" >> "$GITHUB_ENV"')
} else {
	
	# Update the minimal csv
	print("Updating data/endpoints.csv'")
	
	# TEST FAKERY if needed for forcing a data update action when the actual data has not changed
	# endpoints[1,1] <- "test"
	
	write.csv(endpoints, "data/endpoints.csv", row.names = F, na = "")
	
	# Download full metadata
	print("Updating full data.json")
	download.file("https://api.census.gov/data.json", destfile = "data/data.json")
	
	# Update timestamp in update-time.txt
	system('echo "$(TZ=:America/New_York date)" > update-time.txt')
	
	system('echo "UPDATED_DATA=true" >> "$GITHUB_ENV"')
}


