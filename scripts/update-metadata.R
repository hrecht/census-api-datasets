library(censusapi)
library(dplyr)

# Read in old metadata
endpoints_old <- read.csv("data/endpoints.csv")
endpoints_old[endpoints_old == ""] <- NA 

# Get metadata
endpoints <- listCensusApis()

# Sort 
endpoints <- endpoints %>% arrange(desc(vintage), name)

# Is there any difference?
print("Are the old and new endpoints metadata identical?")
print(identical(endpoints_old, endpoints))

write.csv(endpoints, "data/endpoints.csv", row.names = F, na = "")
