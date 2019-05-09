#######################################
# clean the new data
#######################################

library(here)
library(dplyr)
library(plyr)

here()
sales <- read.csv("sales_new.csv", header = T) %>%
  na.omit()
colnames(sales) <- c("month", "sales")
suv_trends <- read.csv("suv_trends_new.csv")
insurance_trends <- read.csv("insurance_trends_new.csv")
colnames(suv_trends) <- c("date", "suv_index")
colnames(insurance_trends) <- c("date", "insurance_index")
trends <- na.omit(join(suv_trends, insurance_trends))

#convert the data to string
trends$date2 <- sapply(X = trends$date, FUN = toString)
#add a column with only the month
trends <- trends %>%
  mutate(month = paste(substring(date2, 1,2 ), 
                       " ", 
                       substring(date2, nchar(date2)-1, nchar(date2)))) %>%
  group_by(month) %>%
  filter(row_number() == 1) %>%
  ungroup() %>%
  select(date, suv_index, insurance_index)

#combine everything into a data frame 
merged <- cbind(trends, sales) %>%
  select(date, sales, suv_index, insurance_index)

#write the merged data
write.csv(merged, file = "merged_new.csv", row.names = FALSE)
