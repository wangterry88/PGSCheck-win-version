############################# Install packages ##############################

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
if("igraph" %in% rownames(installed.packages()) == FALSE) {
        install.packages("igraph",repos = "http://cran.us.r-project.org")
}
if("showtext" %in% rownames(installed.packages()) == FALSE) {
        install.packages("showtext",repos = "http://cran.us.r-project.org")
}
if("stringr" %in% rownames(installed.packages()) == FALSE) {
        install.packages("stringr",repos = "http://cran.us.r-project.org")
}

#############################################################################

options(echo=FALSE,warn=-1) # if you want see commands in output file #To turn warnings back on, use options(warn=0)
gc()
memory.limit(9999999999)

setwd("./")
args <- commandArgs(trailingOnly = TRUE)

Input_search <-args[1]
Output_name  <-args[2]
cut_off      <-args[3]
fam_output   <-args[4]

cut_off<-as.numeric(cut_off)
fam_output<-as.numeric(fam_output)

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
library(igraph)
library(showtext)
library(stringr)

cat('\n')
cat('########### Preparing data..............########### ')
cat('\n')

# Prepare data

PGS_percentile_table<-fread("./data/PGS_percentile_table_ver5.txt",sep="\t",header=T)
Codebook<-fread("./data/PGS_codebook_ver5.txt",sep="\t",header=T)
TPMI_list<-fread("./data/TPMI_list_ver5.txt",sep="\t",header=T,encoding="UTF-8")
Family_table<-fread("./data/TPMI_Family_40W.txt",sep="\t",header=T,encoding="UTF-8")

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
cat('########### Step 2: Plotting All-Risk plot...     ########### ')

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
cat('########### Plotting All-Risk plot sucessfully!...########### ')
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
cat('########### Plotting High-Risk Name plot sucessfully!..########## ')
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
cat('########### Plotting High-Risk Category plot sucessfully!..###########')
cat('\n')
#### Wordcloud Plot ####
cat('\n')
cat('########### Step 5: Plotting Wordcloud plot...############')

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

cat('########### Step 6: Plotting Family plot...###############')

# Family history 

Search_person<-Family_table %>% filter_at(vars(PatientID_1, PatientID_2), any_vars(. %in% Input_search))
check_row<-nrow(Search_person)

if (check_row==0){
    cat('\n')
    cat('\n')
    cat('########### No Family data to plot ! ##########')
    cat('\n')
    cat('\n')
    tmp_all_output<-paste0('./Result/',Output_name,'/')
    writeLines("Your PGS Check result is in following folder:")
    writeLines("\n")
    writeLines(tmp_all_output)
    writeLines("\n")

}else{
    
    if (fam_output==1){

        dir.create(paste0('./Result/',Output_name,'/Family/'))

        cat('\n')
        cat('\n')
        cat('Your input Kingship cutoff is:',cut_off)
        cat('\n')
        cat('\n')
        # Family Relationship Plot

        Search_family_list<-union(Search_person$FamilyID_1, Search_person$FamilyID_2)
        Search_family<-Family_table %>% filter_at(vars(FamilyID_1, FamilyID_2), any_vars(. %in% Search_family_list))

        Search_family_plot<-Search_family[,c("PatientID_1","PatientID_2","PI_HAT")]
        
        Search_family_plot_cutoff<-subset(Search_family_plot,Search_family_plot$PI_HAT>=cut_off)
        Search_family_plot_cutoff$PatientID_1<-str_sub(Search_family_plot_cutoff$PatientID_1, start= -3)
        Search_family_plot_cutoff$PatientID_2<-str_sub(Search_family_plot_cutoff$PatientID_2, start= -3)

        Family_plot_data_tmp=paste0('./Result/',Output_name,'/Family/',Output_name,'.Family.Data.txt',collapse = '')
        fwrite(Search_family_plot_cutoff,Family_plot_data_tmp,sep="\t",col.names=T,bom=T)

        df.graph <- graph.data.frame(Search_family_plot_cutoff, directed = TRUE)

        #### Plot ####

        Family_plot_tmp=paste0('./Result/',Output_name,'/Family/',Output_name,'.Family.plot.png',collapse = '')

        png(filename=Family_plot_tmp,width=1200,height=800)
            par(family='wqy-microhei')
            plot(df.graph, margin=0,
                vertex.size=10,     
                layout=layout_nicely(df.graph),   
                vertex.label.cex=1.0,      
                #vertex.label.font=5,
                main='Family tree',
                vertex.label.family='wqy-microhei',
                edge.arrow.size=0.7)    
        dev.off()
        
        cat('\n')
        cat('########### Plotting Family plot sucessfully!... #########')
        cat('\n')
        cat('\n')

    

        cat('########### Step 7: Plotting Family PRS data... ########')
        cat('\n')
        cat('\n')

        # Family member PGS Check

        Search_family_PRS<-Search_family[,c("PatientID_1","PatientID_2","PI_HAT")]
        Search_family_PRS_cutoff<-subset(Search_family_PRS,Search_family_PRS$PI_HAT>=cut_off)
        Search_family_PRS_list<-union(Search_family_PRS_cutoff$PatientID_1, Search_family_PRS_cutoff$PatientID_2)
        Search_family_PRS_list<-setdiff(Search_family_PRS_list,Input_search)

        ######## For loop Create dirctory ########

        FAM_PGS_NUM <- Search_family_PRS_list

        for (i in 1:length(FAM_PGS_NUM)){

            folder<-dir.create(paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i]))
            cat('\n')
            cat('The Program is now processing:',FAM_PGS_NUM[i])
            cat('\n')
            cat('\n')
            cat('########### Step 7-1: Searching data.......########### ')

            Search<-subset(PGS_percentile_table,PGS_percentile_table$PatientID==FAM_PGS_NUM[i])
            Search_t<-transpose(Search)
            Search_t$ColName<-colnames(Search)
            Search_t<-Search_t[,c(2,1)]

            colnames(Search_t)<-c("Varible","Value")

            Ready_data<-left_join(Search_t,Codebook,by=c("Varible"="PGSID"))

            # Output search result

            search_tmp<-paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.Search.Result.txt',collapse = '')
            fwrite(Ready_data,search_tmp,col.names=T,sep="\t")
            
            cat('\n')
            cat('\n')
            cat('########### Searching data sucessfully!....########### ')
            cat('\n')
            cat('\n')

            ###################### Plot Ready data ############################

            Plot_data<-Ready_data[-c(1:3),]
            Plot_data$Value<-as.numeric(Plot_data$Value)

            cat('########### Step 7-2: Plotting All-Risk plot...  ###########')
            
            cat('\n')

            #### All-Risk.Category ####

            All.box_plot_tmp=paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.All-Risk.Category.Boxplot.png',collapse = '')

                All.box_plot=ggplot(Plot_data, aes(x=Value, y=reorder(Category,Value), fill=Category)) +
                    geom_boxplot(size=1, alpha=0.7) +
                    geom_vline(aes(xintercept=10), colour="#BB0000", linetype="dashed")+
                    geom_vline(aes(xintercept=90), colour="#BB0000", linetype="dashed")+
                    labs( x = "Percentile Rank of Genetic Risk", y = "Trait Category",title =" Box plot of Risk Percentage Rank")+
                    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
                ggsave(All.box_plot,file=All.box_plot_tmp,height = 8,width  = 10, limitsize = FALSE)

            All.box_plot_data_tmp=paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.All-Risk.Category.Boxplot.Data.txt',collapse = '')
            fwrite(Plot_data,All.box_plot_data_tmp,sep="\t",col.names=T)
            cat('\n')
            cat('########### Plotting All-Risk plot sucessfully!..###########')
            cat('\n')
            cat('\n')

            cat('########### Step 7-3: Plotting High-Risk Name plot...###############')
            cat('\n')
            Plot_data_98<-subset(Plot_data,Plot_data$Value>=98)
            Plot_data_98_sort<-Plot_data_98[order(Plot_data_98$Value,decreasing = T),]

            High.box_plot_tmp=paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.High-Risk.Name.Boxplot.png',collapse = '')

                High.box_plot=ggplot(Plot_data_98, aes(x=Value, y=reorder(Reported_Trait,Value), fill=Reported_Trait)) +
                    geom_boxplot(size=1, alpha=0.7) +
                    geom_vline(aes(xintercept=99), colour="#BB0000", linetype="dashed")+
                    labs( x = "Percentile Rank of Genetic Risk", y = "Disease Name",title =" Box plot of High Risk Percentage Rank")+
                    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
                ggsave(High.box_plot,file=High.box_plot_tmp,height = 8,width  = 10, limitsize = FALSE)

            High.box_plot_data_tmp=paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.High-Risk.Name.Boxplot.Data.txt',collapse = '')
            fwrite(Plot_data_98_sort,High.box_plot_data_tmp,sep="\t",col.names=T)
            cat('\n')
            cat('########### Plotting High-Risk Name plot sucessfully!..#############')
            cat('\n')
            cat('\n')

            cat('########### Step 7-4: Plotting High-Risk Category plot...###############')

            High.box_category_plot_tmp=paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.High-Risk.Category.Boxplot.png',collapse = '')

                High.box_category_plot=ggplot(Plot_data_98, aes(x=Value, y=reorder(Category,Value), fill=Category)) +
                    geom_boxplot(size=1, alpha=0.7) +
                    geom_vline(aes(xintercept=99), colour="#BB0000", linetype="dashed")+
                    labs( x = "Percentile Rank of Genetic Risk", y = "Disease Name",title =" Box plot of High Risk Percentage Rank")+
                    theme(axis.text.y = element_text(size=10),axis.text.x = element_text(size=10),legend.position = "none")
                ggsave(High.box_category_plot,file=High.box_category_plot_tmp,height = 8,width  = 10, limitsize = FALSE)

            cat('\n')
            cat('\n')
            cat('########### Plotting High-Risk Category plot sucessfully!..#############')
            cat('\n')
            cat('\n')

            cat('########### Step 7-5: Plotting Wordcloud plot... #######################')

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

            keyword_data_tmp=paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.High-Risk.Keyword.Data.txt',collapse = '')
            fwrite(cloudplot_sort,keyword_data_tmp,sep="\t",col.names=T)

            keyword_plot_tmp=paste0('./Result/',Output_name,'/Family/',FAM_PGS_NUM[i],'/',FAM_PGS_NUM[i],'.High-Risk.Keyword.plot.png',collapse = '')

                png(keyword_plot_tmp, width=500,height=500)

                wordcloud(words = cloudplot$Word, 
                        freq  = cloudplot$Frequence,
                        min.freq = 3,
                        random.order = FALSE,
                        colors = brewer.pal(7, "Dark2"))

                dev.off()

            cat('\n')
            cat('########### Plotting Wordcloud plot sucessfully!..######################')
            cat('\n')
            cat('\n')
            cat('########### Plotting Family PRS sucessfully!... ########')
            cat('\n')
            cat('\n')
            cat('########################################################')
            cat('\n')
        }
    }else{
            cat('\n')
            cat('\n')
            writeLines("You don't want the Family PGS ....Bye Bye!")
            writeLines("\n")
            writeLines("\n")
        }
    }

tmp_all_output<-paste0('./Result/',Output_name,'/')
cat('\n')
cat('\n')
writeLines("Your PGS Check result is in following folder:")
writeLines("\n")
writeLines(tmp_all_output)
writeLines("\n")