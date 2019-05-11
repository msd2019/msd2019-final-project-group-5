# this is to get the original code and data from the authors of the paper


curl -O 'http://people.ischool.berkeley.edu/~hal/Papers/2011/Data.zip'
touch Data.zip
unzip Data.zip
#put all the data in one folder 
cp Examples/Autos/merged.csv data/merged.csv
mv Examples authors_original_code
rm Data.zip