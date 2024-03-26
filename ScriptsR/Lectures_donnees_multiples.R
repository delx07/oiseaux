Lectures_donnees_m=function(fichier){
  
  files = list.files(path = fichier, pattern = ".csv", full.names = TRUE)
  
  # Créez un dataframe vide pour stocker les données combinées
  combined_data = data.frame()
  
  for (file in files) {
    # Lire le fichier CSV
    data <- read.csv(file, header = TRUE, sep=",")  
    # Ajouter les données au dataframe combiné
    combined_data <- bind_rows(combined_data, data)  
  }
  
  #Nettoyage à faire pour les NULL en NA
  combined_data[combined_data== "NULL"]=NA
  #data_oiseaux[is.na(data_oiseaux)]="NULL"
  
  #Enlève les colonne des noms vernaculaire
  combined_data=combined_data[ , c(1:9, 12:18)]
  #Change le format des dates de dd/mm/yyyy à yyyy-mm-dd
  combined_data$date_obs = as.Date(parse_date(combined_data$date_obs))
  #Change le nouveaux type de donnée de la fonction précédente en char
  combined_data$date_obs=as.character(combined_data$date_obs)
  #Série de code pour s'assurer du bon type dans les colonnes
  combined_data$site_id=as.integer(combined_data$site_id)
  combined_data$lat=as.double(combined_data$lat)
  combined_data$time_start=as.character(combined_data$time_start)
  combined_data$time_finish=as.character(combined_data$time_finish)
  combined_data$time_obs=as.character(combined_data$time_obs)
  combined_data$variable=as.character(combined_data$variable)
  combined_data$valid_scientific_name=as.character(combined_data$valid_scientific_name)
  combined_data$rank=as.character(combined_data$rank)
  combined_data$kingdom=as.character(combined_data$kingdom)
  combined_data$phylum=as.character(combined_data$phylum)
  combined_data$class=as.character(combined_data$class)
  combined_data$order=as.character(combined_data$order)
  combined_data$family=as.character(combined_data$family)
  combined_data$genus=as.character(combined_data$genus)
  combined_data$species=as.character(combined_data$species)
  
  #vérifie qu'aucun temps de début est plus petit que son temps de fin
  for (i in 1:30433) {
    if(is.na(combined_data$time_start[i])==FALSE & is.na(combined_data$time_finish[i])==FALSE & hms(combined_data$time_start[i])>hms(combined_data$time_finish[i])){
      ligne=as.character(i)
      message="Time_start plus grand que time_finish à la colonne"
      retour=paste(message,ligne)
      print(retour)
    }
  }
  
  georef=rep("SCRS6622",times=30433)
  
  combined_data=cbind(combined_data, georef)
  
  
  return(combined_data)
}


