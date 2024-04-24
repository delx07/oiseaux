Analyse_oiseaux=function(table){
  
  table1<-as.data.frame(table[1])
  table2<-as.data.frame(table[2])
  table3<-as.data.frame(table[3])
  table4<-as.data.frame(table[4])
  
  #figure 1
  png("Rapport/Figure1.png")
  plot(table1,
       main=c("Abondance journalière moyenne ","selon la latitude des sites"),
       xlab="Latitude (°N)",
       ylab="Abondance journalière moyenne")
  model1 <- lm(avg.abondance. ~ lat, data = table1)
  abline(model1, col="red")
  dev.off()
  
  #figure 2
  png("Rapport/Figure2.png")
  boxplot(table2$avg.abondance.~table2$lat,
              main="Abondance journalière moyenne par classes de latitudes",
              xlab="Latitude (°N)",
              ylab="Abondance journalière moyenne")
  dev.off()
  
  #figure 3
  png("Rapport/Figure3.png")
  plot(table3$lat, table3$abondance,
       main=c("Abondance totale des observations de Passeriformes", "selon la latitude"),
       xlab="Latitude (°N)",
       ylab="Abondance totale")
  model4 <- lm(abondance ~ lat, data = table3)
  abline(model4, col = "blue")
  dev.off()
  
  #figure 4
  library(dplyr)
  library(ggplot2)
  
  png("Rapport/Figure4.png")
  table4$Date <- as.Date(paste(table4$Date, "01", sep = "-"), format = "%Y-%m-%d")
  a0<-table4$abondance[1:12]
  a1<-table4$abondance[13:24]
  a2<-table4$abondance[25:36]
  mat<-rbind(a0,a1,a2)
  mat<-colSums(mat)/3
  as.data.frame(cbind(mat,table4$Date[1:12]))

  toto<-table4[1:12,]
  toto$abondance<-mat
  barplot(mat,
          names.arg = c('janv','févr','mars','avr','mai','juin','juil','août', 'sept','oct','nov','déc'),
          ylim = c(0,2000),
          main=c("Abondance totale mensuelle moyenne des" ,"observations de Passeriformes entre 2016 et 2019"),
          xlab = "Mois",
          ylab="Abondance totale moyenne",
          col = "skyblue")
  dev.off()
  
  
  return(table)
}
