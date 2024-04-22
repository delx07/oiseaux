injection=function(fichier, lien){
  library(dplyr)
  #Ouvre la oiseaux_bd à la base de donnée nommée oiseaux.db par l'objet oiseaux_db
  oiseaux_bd = dbConnect(RSQLite::SQLite(), dbname="oiseaux.db")
  
  #Création de 4 data frame représentant les 4 tables SQL de la base de données, 
  #moins les ID uniques qui seront générés avec la table. On ne fait que sélectionné
  #les colonnes pertinentes
  data_site=fichier[ , c("site_id", "lat", "georef")]
  data_site=distinct(data_site)
  
  data_temps=fichier[ , c("time_start", "time_finish", "date_obs")]
  data_temps=distinct(data_temps)
  
  data_taxonomie=fichier[ , c("valid_scientific_name","rank", "kingdom","phylum","class","order","family","genus","species")]
  #Pour avoir un dataframe avec des valid_scientific_name unique
  duniq=unique(data_taxonomie$valid_scientific_name)
  duniq= as.data.frame(duniq)
  colnames(duniq)="valid_scientific_name"
  duniq2 = left_join(duniq, data_taxonomie, by="valid_scientific_name")
  duniq2=distinct(duniq2)
  data_taxonomie=duniq2
  colnames(data_taxonomie)[6]="ordre"
  
  #écriture des tables en injectant les données de nos dataframe R
  dbWriteTable(oiseaux_bd, append=TRUE, name="site", value=data_site, row.names=FALSE)
  dbWriteTable(oiseaux_bd, append=TRUE, name="taxonomie", value=data_taxonomie, row.names=FALSE)
  dbWriteTable(oiseaux_bd, append=TRUE, name="temps", value=data_temps, row.names=FALSE)
  
  #ajout de id_obs à la table fichier pour ensuite faire le lien dans data_principale et la table principale
  id_merge=dbGetQuery(oiseaux_bd, "SELECT * FROM temps")
  fichier = left_join(id_merge, fichier, by=c("time_start","time_finish","date_obs"))
  
  data_principale=fichier[ , c("variable","time_obs","site_id","valid_scientific_name","id_date")]
  
  dbWriteTable(oiseaux_bd, append=TRUE, name="principale", value=data_principale, row.names=FALSE)
  
  #tableaux test pour voir si la bd est correcte
  test=dbGetQuery(oiseaux_bd, "SELECT date_obs FROM temps ORDER BY date_obs DESC" )
  head(test)
  test2=dbGetQuery(oiseaux_bd, "SELECT * FROM principale" )
  head(test2)
  test3=dbGetQuery(oiseaux_bd, "SELECT * FROM taxonomie")
  head(test3)
  test4=dbGetQuery(oiseaux_bd, "SELECT * FROM temps")
  head(test4)
  test5=dbGetQuery(oiseaux_bd, "SELECT * FROM site")
  head(test5)
  
  #Nous déconnecte de la base de données oiseaux.db pour permettre 
  #l'accès à un autre utilisateur
  dbDisconnect(oiseaux_bd)
  
  #liste pour le retour des tableaux à des fin de débbuging
  liste_test=list(data_temps, data_site, data_taxonomie, data_principale, fichier, test2, test3, test4, test5)
  
  return(liste_test)
  
}