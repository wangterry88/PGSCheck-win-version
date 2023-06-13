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

library(wordcloud)
library(dplyr)
library(data.table)
library(tibble)
library(ggplot2)

# Prepare data
PGS_percentile_table<-fread("./data/PGS_percentile_table_ver3.txt", sep = "\t", header = TRUE, encoding="UTF-8")
TPMI_list<-fread("./data/TPMI_list_ver3.txt",  sep = "\t", header = TRUE,encoding="UTF-8")
phenotype<-fread("./data/phenotype_ver3.txt",sep = "\t", header = TRUE,encoding="UTF-8")
PGS_category_disease_codebook<-fread("./data/PGS_Name_Category_codebook_ver3.txt",sep = "\t", header = TRUE,encoding="UTF-8")

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

##### Map disease Name on Category ######

catgory_plot_df_name<-left_join(catgory_plot_df,PGS_category_disease_codebook,by=c("Index"="Index"))

tmp_catgory_data=paste0('./Result/',Output_name,'/output/',Output_name,'.All-Risk.CategoryName.Data.txt',collapse = '')
write.table(catgory_plot_df_name,tmp_catgory_data,sep='\t',col.names=T,row.names=F, fileEncoding = "UTF-8",quote=FALSE)


##### Map disease Name on Category ######

catgory_name_high_risk<-subset(catgory_plot_df_name,catgory_plot_df_name$Risk_Rank>=98)

tmp_catgory_high_risk=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.CategoryName.Data.txt',collapse = '')
write.table(catgory_name_high_risk,tmp_catgory_high_risk,sep='\t',col.names=T,row.names=F, fileEncoding = "UTF-8",quote=FALSE)


##### Make Frequency table ######

High_risk_result<-catgory_name_high_risk

High_risk_result$Disease_Name<-gsub("\\;"," ",High_risk_result$Disease_Name)
High_risk_result$Disease_Name<-gsub("\\,"," ",High_risk_result$Disease_Name)
High_risk_result$Disease_Name<-gsub("\\("," ",High_risk_result$Disease_Name)
High_risk_result$Disease_Name<-gsub("\\)"," ",High_risk_result$Disease_Name)
High_risk_result$Disease_Name<-gsub("\\/"," ",High_risk_result$Disease_Name)
High_risk_result$Disease_Name<-gsub("\\["," ",High_risk_result$Disease_Name)
High_risk_result$Disease_Name<-gsub("\\]"," ",High_risk_result$Disease_Name)
High_risk_result$Disease_Name<-gsub("\\-"," ",High_risk_result$Disease_Name)

# Make words to lower case
High_risk_result$Disease_Name<-tolower(High_risk_result$Disease_Name) 

#Split sentence
words<-strsplit(High_risk_result$Disease_Name," ")

#Calculate word frequencies

words.freq<-table(unlist(words))
words.freq.df<-as.data.frame(cbind(names(words.freq),as.integer(words.freq)))
colnames(words.freq.df)<-c("Word","Frequence")
words.freq.df$Frequence<-as.integer(words.freq.df$Frequence)

# Remove nonsense words
remove_list<-c("of","in","to","wa","vi","or","%","1","2","a","b","e","v","l","r","")
cloudplot<-subset(words.freq.df,!(words.freq.df$Word %in% remove_list))

keyword_data_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Category.Keyword.Data.txt',collapse = '')

cloudplot_sort<-cloudplot[order(cloudplot$Frequence, decreasing = TRUE),]
fwrite(cloudplot_sort,keyword_data_tmp,sep="\t",col.names=T)

# Output keyword plot data (High boxplot)

keyword_plot_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Category.Keyword.plot.png',collapse = '')

png(keyword_plot_tmp, width=500,height=500)

wordcloud(words = cloudplot$Word, 
          freq  = cloudplot$Frequence,
          min.freq = 3,
          random.order = FALSE,
          colors = brewer.pal(7, "Dark2"))

dev.off()

###### Output plot data (category boxplot) ######

box_plot_output=paste0('./Result/',Output_name,'/output/',Output_name,'.All-Risk.Category.Boxplot.png',collapse = '')

box_plot= ggplot(catgory_plot_df_name, aes(x=Risk_Rank, y=reorder(Category,Risk_Rank), fill=Category)) +
    geom_boxplot(size=1, alpha=0.7) +
    geom_vline(aes(xintercept=10), colour="#BB0000", linetype="dashed")+
    geom_vline(aes(xintercept=90), colour="#BB0000", linetype="dashed")+
    labs( x = "Percentile Rank of Genetic Risk", y = "Trait Category",title =" Box plot of Risk Percentage Rank")+
    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
ggsave(box_plot,file=box_plot_output,height = 8,width  = 10, limitsize = FALSE)

###### Output plot data (High boxplot) ######

high_box_plot_output=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Category.Boxplot.png',collapse = '')

high_box_plot= ggplot(catgory_name_high_risk, aes(x=Risk_Rank, y=reorder(Disease_Name,Risk_Rank), fill=Disease_Name)) +
    geom_boxplot(size=1, alpha=0.7) +
    geom_vline(aes(xintercept=99), colour="#BB0000", linetype="dashed")+
    labs( x = "Percentile Rank of Genetic Risk", y = "Disease Name",title =" Box plot of High Risk Percentage Rank")+
    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
ggsave(high_box_plot,file=high_box_plot_output,height = 8,width  = 10, limitsize = FALSE)

###### Output Real Phenotype data prepare ######

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