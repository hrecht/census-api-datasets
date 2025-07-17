library(censusapi)

# Read in old metadata
endpoints_old <- read.csv("data/endpoints.csv")
endpoints_old[endpoints_old == ""] <- NA 

# Get metadata
endpoints <- listCensusApis()

# Sort (using base R to avoid extra dependencies)
endpoints <- endpoints[order(endpoints$vintage, endpoints$name, decreasing = T),]
row.names(endpoints) <- NULL

# TEST FAKERY if needed for forcing a data update action when the actual data has not changed
# endpoints[1,1] <- "test"

# Fake new row
# fake_row <- endpoints_old[100,]
# fake_row$name <- "test/test"
# fake_row$title <- "My fake dataset"
# fake_row$description <- "This is a fake test."
# endpoints <- rbind(fake_row, endpoints)

# Fake remove row
# endpoints <- endpoints[-27,]

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
	write.csv(endpoints, "data/endpoints.csv", row.names = F, na = "")
	
	# Download full metadata
	print("Updating full data/data.json")
	download.file("https://api.census.gov/data.json", destfile = "data/data.json")
	
	# Update timestamp in update-time.txt
	current_time <- as.POSIXct(Sys.time(),
														 tz = "America/New_York")
	string_time <- format(current_time, "%Y-%m-%d %H:%M:%S")
	writeLines(string_time, "update-time.txt")
	
	system('echo "UPDATED_DATA=true" >> "$GITHUB_ENV"')
}


