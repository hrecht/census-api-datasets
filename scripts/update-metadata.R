# Compare endpoints metadata saved in repo vs the latest
# Save new data if there are changes

# Uses the censusapi listCensusApis() function to extract and format 
# meaningful fields from full metadata at https://api.census.gov/data.json

library(censusapi)

# Read in old metadata
endpoints_old <- read.csv("src/routes/_data/endpoints.csv")
endpoints_old[endpoints_old == ""] <- NA 

# Get metadata
endpoints_new <- listCensusApis()

# Sort (using base R to avoid extra dependencies)
endpoints_new <- endpoints_new[order(endpoints_new$vintage, endpoints_new$name, decreasing = T),]
row.names(endpoints_new) <- NULL

################################################################
# Tests for these functions when the data has not ACTUALLY changed
################################################################
test_changes <- F

if (test_changes == T) {
	system('echo "TEST=TEST" >> "$GITHUB_ENV"')
	# Change a less-important metadata field
	endpoints_new[1,1] <- "test"
	
	# Fake new row
	fake_row <- endpoints_old[100,]
	fake_row$name <- "test/test"
	fake_row$title <- "My fake dataset"
	fake_row$description <- "This is a fake test."
	fake_row$url <- "http://api.census.gov/data/2022/test/test"
	endpoints_new <- rbind(fake_row, endpoints_new)
	
	# Fake remove row
	endpoints_new <- endpoints_new[-27,]
	endpoints_new <- endpoints_new[-300,]
} else {
	system('echo "TEST= " >> "$GITHUB_ENV"')	
}

# Is there any difference?
is_identical <- identical(endpoints_old, endpoints_new)
print("Are the old and new endpoints metadata identical?")
print(is_identical)

current_time <- as.POSIXct(Sys.time(),
													 tz = "America/New_York")
string_time <- format(current_time, "%Y-%m-%d %H:%M")

if (is_identical) {
	print("No data changes")
	system('echo "UPDATED_DATA=false" >> "$GITHUB_ENV"')
	system('echo "MAJOR_CHANGES=false" >> "$GITHUB_ENV"')
	
	commit_message <- paste("No data changes", string_time)
	commit_line <- paste0("COMMIT_MESSAGE='", commit_message, "'", ' >> "$GITHUB_ENV"')
	system(paste('echo ', commit_line))
	
} else {
	
	# If there is a difference, see if there are added and/or removed endpoints
	
	# If the endpoint row changed in some other way like updated
	# description or temporal field I'm less interested in the details
	# save in the git diff but not too important for this project
	
	urls_new <- endpoints_new$url
	urls_old <- endpoints_old$url	

	urls_added <- setdiff(urls_new, urls_old)
	urls_removed <- setdiff(urls_old, urls_new)
	
	if (length(urls_added) > 0 | (length(urls_removed) > 0)) {
		# Extract the full removed or added rows
		
		if (length(urls_added) > 0) {
			print(paste("Endpoint added: ", urls_added))
			rows_added <- endpoints_new[(endpoints_new$url %in% urls_added),]
			rows_added$change <- "Added"
		}
		
		if (length(urls_removed) > 0) {
			print(paste("Endpoint removed: ", urls_removed))
			rows_removed <- endpoints_old[(endpoints_old$url %in% urls_removed),]
			rows_removed$change <- "Removed"
		}
		
		# Construct a df with changes
		if (length(urls_added) > 0 & length(urls_removed) == 0) {
			rows_noted <- rows_added
		}	else if (length(urls_added) == 0 & length(urls_removed) > 0) {
			rows_noted <- rows_removed
		}  else {
			rows_noted <- rbind(rows_added, rows_removed)
		}
		
		rows_noted$change_date <- string_time
		rows_noted <- rows_noted[ , c("change",
														names(rows_noted)[names(rows_noted) != "change"])]
		rows_noted <- rows_noted[ , c("change_date",
																	names(rows_noted)[names(rows_noted) != "change_date"])]
		
		# Append existing file of endpoint additions/deletions
		write.table(rows_noted, file = "src/routes/_data/endpoint-changes.csv",
								sep = ",", append = T, quote = T,
								col.names = F, row.names = F)
		
		# Save status out to env
		system('echo "MAJOR_CHANGES=true" >> "$GITHUB_ENV"')
		
		if (test_changes == TRUE) {
			commit_message <- paste("Major data update TEST", string_time)
		} else {
			commit_message <- paste("Major data update", string_time)
		}

		commit_line <- paste("COMMIT_MESSAGE=", commit_message, ', >> "$GITHUB_ENV"')
		system(paste('echo "', commit_line, '"'))
		
	} else {
		system('echo "MAJOR_CHANGES=false" >> "$GITHUB_ENV"')

		if (test_changes == TRUE) {
			commit_message <- paste("Minor data update TEST", string_time)
		} else {
			commit_message <- paste("Minor data update", string_time)
		}
		commit_line <- paste("COMMIT_MESSAGE=", commit_message, ', >> "$GITHUB_ENV"')
		system(paste('echo "', commit_line, '"'))
	}
	
	# Update the minimal csv
	print("Updating data/endpoints.csv'")
	write.csv(endpoints_new, "src/routes/_data/endpoints.csv", row.names = F, na = "")
	
	# Download full metadata
	print("Updating full data/data.json")
	download.file("https://api.census.gov/data.json", destfile = "data/data.json")
	
	# Save out the update status to Github actions env
	system('echo "UPDATED_DATA=true" >> "$GITHUB_ENV"')
}

# Update timestamp for page
update_json <- paste0('{"updated": "', current_time, '"}')
writeLines(update_json, "src/routes/_data/update-time.json")
