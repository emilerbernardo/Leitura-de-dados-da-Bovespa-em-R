library(dplyr)
library(xts)
library(reshape2)
library(PerformanceAnalytics)
library(BatchGetSymbols)
library(quantmod)
library(tidyr)
#Leitura de dados
dados19<-read.fwf(file="C:/Users/ufc/Documents/COTAHIST_A2019.txt",widths =c(2,8,2,12,3,12,61,11,110), skip = 4)
dados18<-read.fwf(file="C:/Users/ufc/Documents/COTAHIST_A2018.txt",widths =c(2,8,2,12,3,12,61,11,110), skip = 4)

#Variáveis importantes
dados<-rbind(dados18,dados19)
dados<-dados[,c(2,3,4,6,8)]
#Nomes das variáveis
names(dados)<-c("data","bdi","cod","empresa","preco")
#Corrigindo variáveis
dados<-mutate(dados,preco=preco/10^5)
dados$data<-as.Date(dados$data,format = "%Y%m%d")
dados<-filter(dados,data>Sys.Date()-365)
#Filtrando ações do mercado fracionário
dadosf<-filter(dados,bdi==96)
dadosf<-spread(dadosf,key=cod,value = preco)

# Removendo ações pouco transacionadas
dadosf <- dadosf[,colSums(is.na(dadosf))<=0.1*(nrow(dadosf))]
