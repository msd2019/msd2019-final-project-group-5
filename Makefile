# target to make the file report
all: 08_draft_report.html

merged.csv:
	sh 01_get_original_data.sh

sales_04_08.xls suvs_04_08.csv insurance_04_08.csv:  
	sh 02_get_04_08_data.sh

sales_09_13.xls suvs_09_13.csv insurance_09_13.csv: 
	sh 04_get_09_13_data.sh

sales_14_19.xls suvs_14_19.csv insurance_14_19.csv:
	sh 06_get_14_19_data.sh

merged_04_08.csv: sales_04_08.xls suvs_04_08.csv insurance_04_08.csv
	Rscript 03_clean_04_08_data.R

merged_09_13.csv: sales_09_13.xls suvs_09_13.csv insurance_09_13.csv
	Rscript 05_clean_09_13_data.R

merged_14_19.csv: sales_14_19.xls suvs_14_19.csv insurance_14_19.csv
	Rscript 07_clean_14_19_data.R

08_draft_report.html: merged.csv merged_04_08.csv merged_09_13.csv merged_14_19.csv
	Rscript -e "rmarkdown::render('08_draft_report.Rmd')"
