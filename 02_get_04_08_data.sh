# since google trends can only provide data in a weekly format for up to 5 years, and if we try to piece two periods of 5 years together, the normalization will be off, we are breaking the replication and reproduction into three periods, each containing 5 years. This shell sctript is to get the data from  2004/1/1 - 2008/12/31 for both US Census Bureau and Google trends


# sales data
curl -o sales_04_08.xls 'https://www.census.gov/econ/currentdata/export/xls?programCode=MARTS&timeSlotType=12&startYear=2004&endYear=2008&categoryCode=441&dataTypeCode=SM&geoLevelCode=US&adjusted=no&errorData=no&internal=false&vert=1'
touch sales_04_08.xls

# google trends data
# google trends for trucks and suvs
curl -o suvs_04_08.csv 'https://trends.google.com/trends/api/widgetdata/multiline/csv?req=%7B%22time%22%3A%222004-01-01%202008-12-31%22%2C%22resolution%22%3A%22WEEK%22%2C%22locale%22%3A%22en-US%22%2C%22comparisonItem%22%3A%5B%7B%22geo%22%3A%7B%22country%22%3A%22US%22%7D%7D%5D%2C%22requestOptions%22%3A%7B%22property%22%3A%22%22%2C%22backend%22%3A%22IZG%22%2C%22category%22%3A610%7D%7D&token=APP6_UEAAAAAXNcgmuiKeri2K-xQ_DHHOA16r2GERviq&tz=240'
touch suvs_04_08.csv

#google trends data for insurance
curl -o insurance_04_08.csv 'https://trends.google.com/trends/api/widgetdata/multiline/csv?req=%7B%22time%22%3A%222004-01-01%202008-12-31%22%2C%22resolution%22%3A%22WEEK%22%2C%22locale%22%3A%22en-US%22%2C%22comparisonItem%22%3A%5B%7B%22geo%22%3A%7B%22country%22%3A%22US%22%7D%7D%5D%2C%22requestOptions%22%3A%7B%22property%22%3A%22%22%2C%22backend%22%3A%22IZG%22%2C%22category%22%3A467%7D%7D&token=APP6_UEAAAAAXNcgy9i5C0r7PDekewuPm_4XliQ_bVcy&tz=240'
touch insurance_04_08.csv

mv sales_04_08.xls data/sales_04_08.xls 
mv suvs_04_08.csv data/suvs_04_08.csv 
mv insurance_04_08.csv data/insurance_04_08.csv