# This shell sctript is to get the data from  2014/3/1 to 2019/2/28 for both US Census Bureau and Google trends. We chose to end at 2019/2/28 because we want to at least have some months from 2019, and there are only 3-month's worth of US Census Bureau sales data for 2019. 


# sales data
curl -o sales_14_19.xls 'https://www.census.gov/econ/currentdata/export/xls?programCode=MARTS&timeSlotType=12&startYear=2014&endYear=2019&categoryCode=441&dataTypeCode=SM&geoLevelCode=US&adjusted=no&errorData=no&internal=false&vert=1'
touch sales_14_19.xls

# google trends data
# google trends for trucks and suvs
curl -o suvs_14_19.csv 'https://trends.google.com/trends/api/widgetdata/multiline/csv?req=%7B%22time%22%3A%222014-03-01%202019-02-28%22%2C%22resolution%22%3A%22WEEK%22%2C%22locale%22%3A%22en-US%22%2C%22comparisonItem%22%3A%5B%7B%22geo%22%3A%7B%22country%22%3A%22US%22%7D%7D%5D%2C%22requestOptions%22%3A%7B%22property%22%3A%22%22%2C%22backend%22%3A%22IZG%22%2C%22category%22%3A467%7D%7D&token=APP6_UEAAAAAXNcx1ZEsoSKv9XEcae5C3nRwht460Z8B&tz=240'
touch suvs_14_19.csv

#google trends data for insurance
curl -o insurance_14_19.csv 'https://trends.google.com/trends/api/widgetdata/multiline/csv?req=%7B%22time%22%3A%222014-03-01%202019-02-28%22%2C%22resolution%22%3A%22WEEK%22%2C%22locale%22%3A%22en-US%22%2C%22comparisonItem%22%3A%5B%7B%22geo%22%3A%7B%22country%22%3A%22US%22%7D%7D%5D%2C%22requestOptions%22%3A%7B%22property%22%3A%22%22%2C%22backend%22%3A%22IZG%22%2C%22category%22%3A610%7D%7D&token=APP6_UEAAAAAXNcyjwizlepsrROsPf4-iwJ1IiGgE4__&tz=240'
touch insurance_14_19.csv

#move all data to the data folder 
mv sales_14_19.xls data/sales_14_19.xls 
mv suvs_14_19.csv data/suvs_14_19.csv 
mv insurance_14_19.csv data/insurance_14_19.csv