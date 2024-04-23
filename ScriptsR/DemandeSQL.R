Demande_SQL=function(liste_table){
  #Ouvre la oiseaux_bd à la base de donnée nommée oiseaux.db par l'objet oiseaux_db
  oiseaux_bd = dbConnect(RSQLite::SQLite(), dbname="oiseaux.db")
  
  #Demande pour la première figure pour les analyses, cela nous donne la moyenne du nombre 
  #d'observation d'oiseaux par latitude en les regroupant d'abord par date pour permettre 
  #de faire une moyenne par période d'échantillonage 
  tableSQL_Fig1=dbGetQuery(oiseaux_bd, "SELECT lat, avg(abondance) 
    FROM(     
            SELECT lat, date_obs, count(valid_scientific_name) AS abondance 
                 FROM principale
                 LEFT JOIN site ON principale.site_id = site.site_id
                 LEFT JOIN temps ON principale.id_date = temps.id_date
                 GROUP BY lat, date_obs
        )
    GROUP BY lat" )
  
  #Même chose que la demande précédente, mais on regroupe les latitudes par nombre entier 
  tableSQL_Fig2=tableSQL_Fig1
  tableSQL_Fig2$lat=as.integer(tableSQL_Fig1$lat)
  
  #Demande qui permet d'avoir le nombre de passeriforme par latitude
  tableSQL_Fig3=dbGetQuery(oiseaux_bd, "SELECT lat, ordre, count(ordre) AS abondance
             FROM principale
             LEFT JOIN site ON principale.site_id = site.site_id
             LEFT JOIN taxonomie ON principale.valid_scientific_name = taxonomie.valid_scientific_name
             WHERE ordre in ('Passeriformes')
             GROUP BY ordre, lat  " )
  
  #Demande qui permet d'avoir le nomre de passériforme par date
  tableSQL_Fig4=dbGetQuery(oiseaux_bd, "SELECT CONCAT(strftime('%Y', date_obs),'-' ,strftime('%m', date_obs)) AS Date , ordre, COUNT(ordre) AS abondance 
              FROM principale
              LEFT JOIN temps ON principale.id_date = temps.id_date
              LEFT JOIN taxonomie ON principale.valid_scientific_name = taxonomie.valid_scientific_name
              WHERE ordre in ('Passeriformes')
              GROUP BY ordre, strftime('%Y', date_obs),strftime('%m', date_obs)" )
  
  #Liste des tables qui seront utilisé pour faire les figures
  liste_table_SQL=list(tableSQL_Fig1, tableSQL_Fig2, tableSQL_Fig3, tableSQL_Fig4)
  
  
  #Nous déconnecte de la base de données oiseaux.db pour permettre 
  #l'accès à un autre utilisateur
  dbDisconnect(oiseaux_bd)
  
  
  return(liste_table_SQL)
}