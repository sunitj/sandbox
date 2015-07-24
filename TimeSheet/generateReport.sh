#!/bin/bash

# Generate Report
Rscript -e "rmarkdown::render('report.Rmd')" &> report.log

# Move report and related files to appropriate location
MONTHS=(ZERO January February March April May June July August September October November December)
this_month=`date +%m`
this_year=`date +%Y`
mv *.pdf *.log data/${MONTHS[$this_month]}_${this_year}/
