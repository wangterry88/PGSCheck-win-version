options(echo=FALSE,warn=0) # if you want see commands in output file #To turn warnings back on, use options(warn=0)

gc()
memory.limit(9999999999)

setwd("./")
args <- commandArgs(trailingOnly = TRUE)

Input_search <-args[1]
Output_name  <-args[2]

cat('\n')
writeLines("Your input search Patient ID is:")
cat('\n')
writeLines(Input_search)
writeLines("\n")
writeLines("Your output file name is:")
cat('\n')
writeLines(Output_name)

# Make Output data
dir.create(paste0("./Result/",Output_name,"/"))
dir.create(paste0("./Result/",Output_name,"/output/"))

library(dplyr)
library(data.table)
library(tibble)
library(ggplot2)


# Prepare data
PGS_percentile_table<-fread("./data/PGS_percentile_table_ver2.txt", sep = "\t", header = TRUE, encoding="UTF-8")
TPMI_list<-fread("./data/TPMI_list_ver2.txt",  sep = "\t", header = TRUE,encoding="UTF-8")
phenotype<-fread("./data/phenotype_ver2.txt",sep = "\t", header = TRUE,encoding="UTF-8")

# Output Search Result
Search_result<-subset(PGS_percentile_table,PGS_percentile_table$PatientID==Input_search)
Search_result_t<-transpose(Search_result)
Search_result_t$ColName<-colnames(Search_result)
Search_result_t<-Search_result_t[,c("ColName","V1")]
colnames(Search_result_t)[2]<-c("Value")

#### Plot (category boxplot) #### 
catgory_plot<-Search_result_t
colnames(catgory_plot)[1]<-c("Category")
colnames(catgory_plot)[2]<-c("Risk_Rank")

catgory_plot_df<-catgory_plot[-c(1:3),]
catgory_plot_df$Risk_Rank<-as.numeric(catgory_plot_df$Risk_Rank)
catgory_plot_df$Index<-1:nrow(catgory_plot_df)
catgory_plot_df<-catgory_plot_df[,c("Index","Category","Risk_Rank")]

tmp_catgory_data=paste0('./Result/',Output_name,'/output/',Output_name,'.Risk.Category.Data.txt',collapse = '')
write.table(catgory_plot_df,tmp_catgory_data,sep='\t',col.names=T,row.names=F, fileEncoding = "UTF-8",quote=FALSE)

# Output plot data (category boxplot)

box_plot_output=paste0('./Result/',Output_name,'/output/',Output_name,'.Risk.Category.Boxplot.png',collapse = '')

box_plot= ggplot(catgory_plot_df, aes(x=Risk_Rank, y=reorder(Category,Risk_Rank), fill=Category)) +
    geom_boxplot(size=1, alpha=0.7) +
    geom_vline(aes(xintercept=10), colour="#BB0000", linetype="dashed")+
    geom_vline(aes(xintercept=90), colour="#BB0000", linetype="dashed")+
    labs( x = "Percentile Rank of Genetic Risk", y = "Trait Category",title =" Box plot of Risk Percentage Rank")+
    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
ggsave(box_plot,file=box_plot_output,height = 8,width  = 10, limitsize = FALSE)

# Output Real Phenotype data prepare

pheno_out<-subset(phenotype,phenotype$PatientID==Input_search)
pheno_out_t<-transpose(pheno_out)
pheno_out_t$Disease_Name<-colnames(phenotype)

colnames(pheno_out_t)[1]<-c("Pheno")
pheno_out_t<-pheno_out_t[,c("Disease_Name","Pheno")]
pheno_out_diagnosed<-subset(pheno_out_t,pheno_out_t$Pheno=="1")

tmp_pheno_out_diagnosed<-paste0('./Result/',Output_name,'/output/',Output_name,'.Phencode.Real.Diagnosed.txt',collapse = '')
write.table(pheno_out_diagnosed,tmp_pheno_out_diagnosed,sep='\t',col.names=T,row.names=F, fileEncoding = "UTF-8",quote=FALSE)

tmp_all_output<-paste0('./Result/',Output_name,'/')

writeLines("Your PGS Check result is in following folder:")
writeLines("\n")
writeLines(tmp_all_output)
writeLines("\n")