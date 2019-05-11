# This shell sctript is to get the data from  2009/1/1 to 2013/12/31 for both US Census Bureau and Google trends

# sales data
curl -o sales_09_13.xls 'https://www.census.gov/econ/currentdata/export/xls?programCode=MARTS&timeSlotType=12&startYear=2009&endYear=2013&categoryCode=441&dataTypeCode=SM&geoLevelCode=US&adjusted=no&errorData=no&internal=false&vert=1'
touch sales_09_13.xls

# google trends data
# google trends for trucks and suvs
curl -o suvs_09_13.csv 'https://trends.google.com/trends/api/widgetdata/multiline/csv?req=%7B%22time%22%3A%222009-01-01%202013-12-31%22%2C%22resolution%22%3A%22WEEK%22%2C%22locale%22%3A%22en-US%22%2C%22comparisonItem%22%3A%5B%7B%22geo%22%3A%7B%22country%22%3A%22US%22%7D%7D%5D%2C%22requestOptions%22%3A%7B%22property%22%3A%22%22%2C%22backend%22%3A%22IZG%22%2C%22category%22%3A610%7D%7D&token=APP6_UEAAAAAXNdFlp924tNn70ha_nszyjDnoxYuDu9b&tz=240'
touch suvs_09_13.csv

#google trends data for insurance
curl -o insurance_09_13.csv 'https://trends.google.com/trends/api/widgetdata/multiline/csv?req=%7B%22time%22%3A%222009-01-01%202013-12-31%22%2C%22resolution%22%3A%22WEEK%22%2C%22locale%22%3A%22en-US%22%2C%22comparisonItem%22%3A%5B%7B%22geo%22%3A%7B%22country%22%3A%22US%22%7D%7D%5D%2C%22requestOptions%22%3A%7B%22property%22%3A%22%22%2C%22backend%22%3A%22IZG%22%2C%22category%22%3A467%7D%7D&token=APP6_UEAAAAAXNdbIpsDozQGum3S1chLej1JLcuPy6pw&tz=240'
touch insurance_09_13.csv

mv sales_09_13.xls data/sales_09_13.xls 
mv suvs_09_13.csv data/suvs_09_13.csv 
mv insurance_09_13.csv data/insurance_09_13.csv