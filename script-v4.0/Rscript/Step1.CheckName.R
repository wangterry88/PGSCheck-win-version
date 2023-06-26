options(echo=FALSE,warn=-1) # if you want see commands in output file #To turn warnings back on, use options(warn=0)
setwd("./")

####### Install packages ###########

#### data.table ######
if("data.table" %in% rownames(installed.packages()) == FALSE) {
        install.packages("data.table",repos = "http://cran.us.r-project.org")
}
##### dplyr ######
if("dplyr" %in% rownames(installed.packages()) == FALSE) {
        install.packages("dplyr",repos = "http://cran.us.r-project.org")
}
#### ggplot2 ######
if("ggplot2" %in% rownames(installed.packages()) == FALSE) {
	install.packages("ggplot2",repos = "http://cran.rstudio.org")
}
#### tibble ######
if("tibble" %in% rownames(installed.packages()) == FALSE) {
	install.packages("tibble",repos = "http://cran.us.r-project.org")
}
#### bit64 ######
if("bit64" %in% rownames(installed.packages()) == FALSE) {
	install.packages("bit64",repos = "http://cran.us.r-project.org")
}
if("wordcloud" %in% rownames(installed.packages()) == FALSE) {
	install.packages("wordcloud",repos = "http://cran.us.r-project.org")
}

args <- commandArgs(trailingOnly = TRUE)
Patient_name<-args[1]

library(dplyr)
library(data.table)

TPMI_list<-fread("./data/TPMI_list_ver4.txt", sep = "\t", header = TRUE,encoding="UTF-8")

# Read user input data

Input=as.character(Patient_name)
TPMI_list_selection<-subset(TPMI_list,TPMI_list$PatientName==Input)

# Print selection list
writeLines('\n')
print(TPMI_list_selection)
writeLines('\n')
writeLines("Please Right click to copy PatientID, and close the window to perform next program....")
writeLines('\n')