Analyse_oiseaux=function(table){
  
  dataFrame=as.data.frame(table[1])
  png("Figure_1.png")
  barplot(dataFrame)
  dev.off()
  
  dataFrame=as.data.frame(table[2])
  png("Figure_2.png")
  barplot(dataFrame)
  dev.off()
  
  return(table)
}