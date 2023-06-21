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
cat('\n')
cat('\n')
# Make Output data
dir.create(paste0("./Result/",Output_name,"/"))
dir.create(paste0("./Result/",Output_name,"/output/"))

library(dplyr)
library(data.table)
library(wordcloud)
library(tibble)
library(ggplot2)

cat('\n')
cat('########### Preparing data..............########### ')
cat('\n')

# Prepare data

PGS_percentile_table<-fread("./data/PGS_percentile_table_ver4.txt",sep="\t",header=T)
Codebook<-fread("./data/PGS_codebook_ver4.txt",sep="\t",header=T)
TPMI_list<-fread("./data/TPMI_list_ver4.txt",sep="\t",header=T,encoding="UTF-8")

cat('\n')
cat('########### Preparing data sucessfully!..########### ')
cat('\n')

# Start Search
cat('\n')
cat('########### Step 1: Searching data.......########### ')
cat('\n')
Search<-subset(PGS_percentile_table,PGS_percentile_table$PatientID==Input_search)

Search_t<-transpose(Search)
Search_t$ColName<-colnames(Search)
Search_t<-Search_t[,c(2,1)]
colnames(Search_t)<-c("Varible","Value")

Ready_data<-left_join(Search_t,Codebook,by=c("Varible"="PGSID"))

# Output search result

search_tmp<-paste0('./Result/',Output_name,'/output/',Output_name,'.Search.Result.txt',collapse = '')
fwrite(Ready_data,search_tmp,col.names=T,sep="\t")
cat('\n')
cat('########### Searching data sucessfully!....########### ')
cat('\n')
###################### Plot Ready data ############################

Plot_data<-Ready_data[-c(1:3),]
Plot_data$Value<-as.numeric(Plot_data$Value)

cat('\n')
cat('########### Step 2: Plotting All-Risk plot..########### ')
cat('\n')

#### All-Risk.Category ####

All.box_plot_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.All-Risk.Category.Boxplot.png',collapse = '')

All.box_plot=ggplot(Plot_data, aes(x=Value, y=reorder(Category,Value), fill=Category)) +
    geom_boxplot(size=1, alpha=0.7) +
    geom_vline(aes(xintercept=10), colour="#BB0000", linetype="dashed")+
    geom_vline(aes(xintercept=90), colour="#BB0000", linetype="dashed")+
    labs( x = "Percentile Rank of Genetic Risk", y = "Trait Category",title =" Box plot of Risk Percentage Rank")+
    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
ggsave(All.box_plot,file=All.box_plot_tmp,height = 8,width  = 10, limitsize = FALSE)

All.box_plot_data_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.All-Risk.Category.Boxplot.Data.txt',collapse = '')
fwrite(Plot_data,All.box_plot_data_tmp,sep="\t",col.names=T)
cat('\n')
cat('########### Plotting All-Risk plot sucessfully!..########### ')
cat('\n')
#### High-Risk.Category ####

cat('\n')
cat('########### Step 3: Plotting High-Risk Name plot...###############')
cat('\n')

Plot_data_98<-subset(Plot_data,Plot_data$Value>=98)
Plot_data_98_sort<-Plot_data_98[order(Plot_data_98$Value,decreasing = T),]

High.box_plot_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Name.Boxplot.png',collapse = '')

High.box_plot=ggplot(Plot_data_98, aes(x=Value, y=reorder(Reported_Trait,Value), fill=Reported_Trait)) +
    geom_boxplot(size=1, alpha=0.7) +
    geom_vline(aes(xintercept=99), colour="#BB0000", linetype="dashed")+
    labs( x = "Percentile Rank of Genetic Risk", y = "Disease Name",title =" Box plot of High Risk Percentage Rank")+
    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
ggsave(High.box_plot,file=High.box_plot_tmp,height = 8,width  = 10, limitsize = FALSE)

High.box_plot_data_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Name.Boxplot.Data.txt',collapse = '')
fwrite(Plot_data_98_sort,High.box_plot_data_tmp,sep="\t",col.names=T)
cat('\n')
cat('########### Plotting High-Risk Name plot sucessfully!..####### ')
cat('\n')
cat('\n')
cat('########### Step 4: Plotting High-Risk Category plot...###############')
cat('\n')

High.box_category_plot_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Category.Boxplot.png',collapse = '')

High.box_category_plot=ggplot(Plot_data_98, aes(x=Value, y=reorder(Category,Value), fill=Category)) +
    geom_boxplot(size=1, alpha=0.7) +
    geom_vline(aes(xintercept=99), colour="#BB0000", linetype="dashed")+
    labs( x = "Percentile Rank of Genetic Risk", y = "Disease Name",title =" Box plot of High Risk Percentage Rank")+
    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
ggsave(High.box_category_plot,file=High.box_category_plot_tmp,height = 8,width  = 10, limitsize = FALSE)

cat('\n')
cat('########### Plotting High-Risk Category plot sucessfully!..####### ')
cat('\n')
#### Wordcloud Plot ####
cat('\n')
cat('########### Step 5: Plotting Wordcloud plot...############ ')
cat('\n')
cat('\n')
wordcloud_plot<-Plot_data_98[,c("Reported_Trait")]
wordcloud_plot$Reported_Trait<-gsub("\\;"," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-gsub("\\,"," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-gsub("\\("," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-gsub("\\)"," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-gsub("\\/"," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-gsub("\\["," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-gsub("\\]"," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-gsub("\\-"," ",wordcloud_plot$Reported_Trait)
wordcloud_plot$Reported_Trait<-tolower(wordcloud_plot$Reported_Trait)

#Split sentence
words<-strsplit(wordcloud_plot$Reported_Trait," ")

#Calculate word frequencies
words.freq<-table(unlist(words))
words.freq.df<-as.data.frame(cbind(names(words.freq),as.integer(words.freq)))
colnames(words.freq.df)<-c("Word","Frequence")
words.freq.df$Frequence<-as.integer(words.freq.df$Frequence)

# Remove nonsense words
remove_list<-c("of","in","to","wa","vi","or","%","1","2","3","18","10","a","b","c","e","v","l","r","")
cloudplot<-subset(words.freq.df,!(words.freq.df$Word %in% remove_list))

cloudplot_sort<-cloudplot[order(cloudplot$Frequence, decreasing = TRUE),]

keyword_data_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Keyword.Data.txt',collapse = '')
fwrite(cloudplot_sort,keyword_data_tmp,sep="\t",col.names=T)

keyword_plot_tmp=paste0('./Result/',Output_name,'/output/',Output_name,'.High-Risk.Keyword.plot.png',collapse = '')

png(keyword_plot_tmp, width=500,height=500)

wordcloud(words = cloudplot$Word, 
          freq  = cloudplot$Frequence,
          min.freq = 3,
          random.order = FALSE,
          colors = brewer.pal(7, "Dark2"))

dev.off()

cat('\n')
cat('########### Plotting Wordcloud plot sucessfully!..########')
cat('\n')
cat('\n')
tmp_all_output<-paste0('./Result/',Output_name,'/')
writeLines("Your PGS Check result is in following folder:")
writeLines("\n")
writeLines(tmp_all_output)
writeLines("\n")