#!/bin/bash

Rscript -e "rmarkdown::render('report.Rmd')" &> report.log

MONTHS=(ZERO January February March April May June July August September October November December)
this_month=`date +%m`
this_year=`date +%Y`
mv Figs *.pdf *.log data/${MONTHS[$this_month]}_${this_year}/
