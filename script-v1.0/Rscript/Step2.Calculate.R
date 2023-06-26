#Sys.setlocale(category = "LC_ALL", locale = "cht")
options(echo=FALSE,warn=-1) # if you want see commands in output file #To turn warnings back on, use options(warn=0)

setwd("./")
args <- commandArgs(trailingOnly = TRUE)

Input_search <-args[1]
Output_name  <-args[2]

writeLines("Your input search ID number is:")
writeLines(Input_search)
writeLines("\n")
writeLines("Your output file name is:")
writeLines(Output_name)

# Make Output data
dir.create(paste0("./Result/",Output_name,"/"))
dir.create(paste0("./Result/",Output_name,"/output/"))

library(dplyr)
library(data.table)
library(tibble)
library(ggplot2)

# Prepare data
PGS_percentile_table<-fread("./data/PGS_percentile_table.txt", sep = "\t", header = TRUE,encoding="UTF-8")
TPMI_list<-fread("./data/TPMI_list.txt",  sep = "\t", header = TRUE,encoding="UTF-8")
PGS_category<-read.csv("./data/PGS_category.txt",sep = "\t", header = TRUE,encoding="UTF-8")
phenotype<-fread("./data/phenotype.txt",sep = "\t", header = TRUE,encoding="UTF-8")

# Recoding
PGS_category$Reported_Trait<-iconv(PGS_category$Reported_Trait, from = "UTF-8", to = "ASCII", sub = "")

# Output Search Result
output_search<-subset(PGS_percentile_table,PGS_percentile_table$IdNo==Input_search)
output_search<-output_search[,-c("ChipID")]

output_search_df<-output_search
output_search_df_t<-transpose(output_search_df)
output_search_df_t$ColName<-colnames(output_search_df)
output_search_df_t<-output_search_df_t[,c("ColName","V1")]
colnames(output_search_df_t)[2]<-c("Value")
output_search_df_t$Value <-enc2utf8(output_search_df_t$Value)
output_search_df_t$ColName<-iconv(output_search_df_t$ColName, from = "UTF-8", to = "ASCII", sub = "")

result_output=paste0('./Result/',Output_name,'/output/',Output_name,'.Risk.Percentage.Data.txt',collapse = '')
fwrite(output_search_df_t,result_output,sep="\t",col.names=T, bom = T)

# Output Real Phenotype data prepare
pheno_out<-subset(phenotype,phenotype$IdNo==Input_search)
pheno_out_t<-transpose(pheno_out)
pheno_out_t$Disease_Name<-colnames(phenotype)

colnames(pheno_out_t)[1]<-c("Pheno")
pheno_out_t<-pheno_out_t[,c("Disease_Name","Pheno")]
pheno_out_diagnosed<-subset(pheno_out_t,pheno_out_t$Pheno=="1")
pheno_out_diagnosed$Disease_Name<-iconv(pheno_out_diagnosed$Disease_Name, from = "UTF-8", to = "ASCII", sub = "")

tmp_pheno_out_diagnosed<-paste0('./Result/',Output_name,'/output/',Output_name,'.Phencode.Real.Diagnosed.txt',collapse = '')
fwrite(pheno_out_diagnosed,tmp_pheno_out_diagnosed,sep="\t",col.names=T, bom = T)

#### Plot (category boxplot) #### 
catgory_plot<-output_search_df_t
colnames(catgory_plot)[2]<-c("Risk_Rank")

catgory_plot_df<-catgory_plot[-c(1:5),]
catgory_plot_df$Risk_Rank<-as.numeric(catgory_plot_df$Risk_Rank)
catgory_plot_df$Index<-1:nrow(catgory_plot_df)

# Get the category data
catgory_plot_df_catgory<-left_join(catgory_plot_df,PGS_category,by=c("ColName"="Reported_Trait"),relationship = "many-to-many")
catgory_plot_df_catgory<-na.omit(catgory_plot_df_catgory)
catgory_plot_df_catgory_uni<-distinct(catgory_plot_df_catgory,Index,.keep_all=T)

# Output catgory data
catgory_data<-catgory_plot_df_catgory_uni
catgory_data<-catgory_data[,c("Index","Trait_Category","ColName","Risk_Rank")]
catgory_data$ColName<-iconv(catgory_data$ColName, from = "UTF-8", to = "ASCII", sub = "")

tmp_catgory_data=paste0('./Result/',Output_name,'/output/',Output_name,'.Risk.Category.Data.txt',collapse = '')
fwrite(catgory_data,tmp_catgory_data,sep="\t",col.names=T, bom = T)

# Output plot data (category boxplot)
box_plot_output=paste0('./Result/',Output_name,'/output/',Output_name,'.Full.Risk.Boxplot.png',collapse = '')

box_plot= ggplot(catgory_plot_df_catgory_uni, aes(x=Risk_Rank, y=reorder(Trait_Category,Risk_Rank), fill=Trait_Category)) +
    geom_boxplot(size=1, alpha=0.7) +
    geom_vline(aes(xintercept=10), colour="#BB0000", linetype="dashed")+
    geom_vline(aes(xintercept=90), colour="#BB0000", linetype="dashed")+
    labs( x = "Percentile Rank of Genetic Risk", y = "PGS Trait Category",title =" Box plot of Risk Percentage Rank")+
    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
ggsave(box_plot,file=box_plot_output,height = 8,width  = 10, limitsize = FALSE)

tmp_all_output<-paste0('./Result/',Output_name,'/')

writeLines("Your PGS Check result is in following folder:")
writeLines("\n")
writeLines(tmp_all_output)
writeLines("\n")