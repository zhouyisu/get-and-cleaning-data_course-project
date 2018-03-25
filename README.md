# get-and-cleaning-data_course-project
Course project for Coursera course Getting and Cleaning Data from JHU


## Description

`run_analysis.R` is a self-contained R script. It will:
- Download the file from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
- Unzip it to the working directory
- Perform the 5 tasks as decsribed in the [project description](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project)
- The newly-created tidy dataset is called **tidydata.txt**
- Alternatively, knitting the `codebook.rmd` rmarkdown will also perform the above tasks plus producing a codebook in HTML format for the user.
- To preview codebook: <http://htmlpreview.github.io/?https://github.com/zhouyisu/get-and-cleaning-data_course-project/blob/master/codebook.html>

## Dependencies
- `here` to build platform independent path <https://cran.r-project.org/package=here>
- `memisc` to create codebook
- `knitr` to produce html (by default `knitr` is installed by Rstudio)
- `tidyverse` for data manipulation
