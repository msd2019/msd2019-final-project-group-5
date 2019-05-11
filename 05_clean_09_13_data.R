#######################################
# clean second group of data
# 2009/01-2013/12 google trends data for trucks & suvs and auto insurance
# 2009/01-2013/12 sales data from us census bureau
#######################################

library(plyr)
library(readxl)
library(dplyr)
library(here)

#clean sales data
sales <- read_excel("data/sales_09_13.xls")[,-3][-c(1:7), ]
colnames(sales) <- c("month", "sales")

#clean google trends data and leave only the data for the first weeks of each month
suv_trends <- read.csv("data/suvs_09_13.csv", row.names = NULL)[-1,]
insurance_trends <- read.csv("data/insurance_09_13.csv", row.names = NULL)[-1,]
colnames(suv_trends) <- c("Period", "suvs")
colnames(insurance_trends) <- c("Period", "insurance")
trends <- join(suv_trends, insurance_trends)
# add a column with only the month and group by filter to only first week
trends <- trends %>%
  mutate(month = substring(Period, 1,7)) %>%
  group_by(month) %>%
  filter(row_number() == 1) %>%
  ungroup() %>%
  select(Period, suvs, insurance)

# change the date back to the format needed for training, eg. "2009/02/01"
trends$Period <- as.Date(trends$Period)
trends$Period <- format(trends$Period, "%Y/%m/%d")

# combine everything into a data frame
merged <- cbind(trends, sales) %>%
  select(Period, sales, suvs, insurance)

#write the merged data
write.csv(merged, file = "data/merged_09_13.csv", row.names = FALSE)
