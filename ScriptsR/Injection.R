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
  
  #écriture des tables en injectant les données de nos dataframe R, seulement pour les trois tables secondaires
  dbWriteTable(oiseaux_bd, append=TRUE, name="site", value=data_site, row.names=FALSE)
  dbWriteTable(oiseaux_bd, append=TRUE, name="taxonomie", value=data_taxonomie, row.names=FALSE)
  dbWriteTable(oiseaux_bd, append=TRUE, name="temps", value=data_temps, row.names=FALSE)
  
  #ajout de id_obs à la table fichier pour ensuite faire le lien dans data_principale et la table principale
  id_merge=dbGetQuery(oiseaux_bd, "SELECT * FROM temps")
  fichier = left_join(id_merge, fichier, by=c("time_start","time_finish","date_obs"))
  data_principale=fichier[ , c("variable","time_obs","site_id","valid_scientific_name","id_date")]
  #injection des données dans la table principale
  dbWriteTable(oiseaux_bd, append=TRUE, name="principale", value=data_principale, row.names=FALSE)
  
  #Nous déconnecte de la base de données oiseaux.db pour permettre 
  #l'accès à un autre utilisateur
  dbDisconnect(oiseaux_bd)
  
  return(fichier)
  
}