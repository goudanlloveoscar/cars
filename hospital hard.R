library(readxl)
library(tidyverse)
library(writexl)
library(stringr)
adata<- read_excel("C:/Users/liwu2101/Downloads/MS Analyses-21E04 V2 624_Hospital DDD data -2021 June.xlsx", 
                 sheet = "Sheet7")  ####读取数据

adatalong = gather(adata,period,value,"201901 Val":"202105 Vol",factor_key=TRUE) ###转换成长数据
adatalong2 <- unite(adatalong,"time_hos",period,Hospital)  ###合并两列，为了匹配
adatano0 <- adatalong2[-which(is.na(adatalong$value|adatalong$value==0)),]  ####去除是na或者是0的每个月的数据
product <- c("Rhinocort","YQ","Flixonase Aqua     Gsk","Nax")  ###定义品牌

Rhi <- subset(adatano0,adatano0$Product=="Rhinocort") ###subset出特定产品的数据
YQ <- subset(adatano0,adatano0$Product=="YQ")   ##
Flix <- subset(adatano0,adatano0$Product=="Flixonase Aqua     Gsk")##
Nax <- subset(adatano0,adatano0$Product=="Nax")##
Rhi_YQ <- merge(Rhi,YQ,by="time_hos") %>%  separate("time_hos",c("time","hos"),"_") ###
##因为要对比本品和竞品 所以合并两个品牌的数据 然后把两列分开
#### 注意！！！merge已经有去除重复的效果，因为by只有大家都有的才会合并
Rhi_Flix <- merge(Rhi,Flix,by="time_hos")%>%  separate("time_hos",c("time","hos"),"_")#
Rhi_Nax <- merge(Rhi,Nax,by="time_hos")%>%  separate("time_hos",c("time","hos"),"_")#
# write_xlsx(Rhi_YQ,"C:/Users/liwu2101/Downloads/Rhi_YQ12222.xlsx")#导出数据
# write_xlsx(Rhi_Flix,"C:/Users/liwu2101/Downloads/Rhi_Flix12222.xlsx")#
# write_xlsx(Rhi_Nax,"C:/Users/liwu2101/Downloads/Rhi_Nax122222.xlsx")#

province <- c("Beijing","Chongqing","Guangdong","Hebei","Henan","Hubei",
              "Hunan","Jiangsu","Shandong","Shanghai","Sichuan","Zhejiang") ##定义比较的省份
# names(adata)
timeval <- names(adata)[5:33]   ###定义val时间
timevol <- names(adata)[34:62]  ###定义vol时间

nhos1 <- c()
nvalx1 <- c()
nvaly1 <- c()
tt1 <- c()
prov1 <- c()

cal <- function(x,c1,c2){
for (i in 1:length(province)){
  for (m in 1:length(timeval)){
    tt1 <- append(tt1,timeval[m])
    prov1 <- append(prov1,province[i])
    nvalx1 <- append(nvalx1,sum(x[x[c1]==province[i] & x[c2]==timeval[m],6]))
    nvaly1 <- append(nvaly1,sum(x[x[c1]==province[i] & x[c2]==timeval[m],10]))
    nhos1 <- append(nhos1,nrow(x[x[c1]==province[i] & x[c2]==timeval[m],]))
  }
}
out1 <<- data.frame("prov"=c(prov1),"time"=tt1,"nhos"=c(nhos1),"sales_value_R"=c(nvalx1),"sales value_competiter"=c(nvaly1))

}

cal(Rhi_YQ,"Province.x","time")

# for (i in 1:length(province)){
#   for (m in 1:length(timeval)){
#     
#     tt1 <- append(tt1,timeval[m])
#     prov1 <- append(prov1,province[i])
#     nvalx1 <- append(nvalx1,sum(rf[rf$Province.x==province[i] & rf$time==timeval[m],5]))
#     nvaly1 <- append(nvaly1,sum(rf[rf$Province.x==province[i] & rf$time==timeval[m],9]))
#     nhos1 <- append(nhos1,nrow(rf[rf$Province.x==province[i] & rf$time==timeval[m],]))
#   }
# }

