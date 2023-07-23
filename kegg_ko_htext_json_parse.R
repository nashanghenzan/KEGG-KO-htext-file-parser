#See whether these packages exist on comp. If not, install.
package_list <- c("optparse","rjson","stringr","tidyr")

for(p in package_list){
  if(!suppressWarnings(suppressMessages(require(p, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)))){
    install.packages(p, repos="http://cran.r-project.org")
    suppressWarnings(suppressMessages(library(p, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)))
  }
}

#clean enviroment object
rm(list=ls()) 

#Load essential packages
library(optparse)
library(rjson)
library(stringr)
library(tidyr)

#Make option
option_list = list(make_option(c("-i", "--input"), type = "character", default = NULL,
                               help="kegg htext json file"))         
apt = parse_args(OptionParser(option_list=option_list))

#Load json file
jsonData = fromJSON(file = apt$input)
a=jsonData$name
b=jsonData$children

#Parse json file
c=NULL
for (i in 1:length(b)) {
  for (j in 1:length(b[[i]]$children)) {
    for (w in 1:length(b[[i]]$children[[j]]$children)) {
      for (x in 1:length(b[[i]]$children[[j]]$children[[w]]$children)) {
        
        c=rbind(c,c(
          b[[i]]$name,
          b[[i]]$children[[j]]$name,
          b[[i]]$children[[j]]$children[[w]]$name,
          b[[i]]$children[[j]]$children[[w]]$children[[x]]$name
        ))
        
      }
    }  
  }
}

#Remove useless number
c=as.data.frame(c)
c$V1=substring(c$V1,7,nchar(c$V1))
c$V2=substring(c$V2,7,nchar(c$V2))
c$V3=substring(c$V3,7,nchar(c$V3))

#Get KEGG pathway
d = separate(data=c, col = V3,  into=c('V3', 'pathway_id'), sep ="[[]" )
d$pathway_id =str_replace_all(d$pathway_id,c("]"=""))

#Get KEGG Orthology (KO)
d$V4 =sub("  ", "$", d$V4)
d = separate(data=d, col = V4,  into=c('V4', 'KO_name'), sep ="[$]" )

#Get kegg gene name
d$KO_name =sub(";", "$", d$KO_name)
d = separate(data=d, col = KO_name,  into=c('gene', 'KO_name'), sep ="[$]" )

#Separate KO and EC
d$KO_name =sub("[[]EC:", "$", d$KO_name)
d = separate(data=d, col = KO_name,  into=c('KO_name', 'EC'), sep ="[$]" )
d$EC =gsub("[]]", "", d$EC)

names(d)[c(1,2,3,5)]=c("level1","level2","level3","KO")
write.table(d, file = "kegg htext.txt", quote = F, sep = "\t", row.names = F, col.names = T)