Demande_SQL=function(liste_table){
  #Ouvre la oiseaux_bd à la base de donnée nommée oiseaux.db par l'objet oiseaux_db
  oiseaux_bd = dbConnect(RSQLite::SQLite(), dbname="oiseaux.db")
  
  tableSQL_Fig1=dbGetQuery(oiseaux_bd, "SELECT lat, avg(abondance) 
    FROM(     
            SELECT lat, date_obs, count(valid_scientific_name) AS abondance 
                 FROM principale
                 LEFT JOIN site ON principale.site_id = site.site_id
                 LEFT JOIN temps ON principale.id_date = temps.id_date
                 GROUP BY lat, date_obs
        )
    GROUP BY lat" )
  
  
  tableSQL_Fig2=tableSQL_Fig1
  tableSQL_Fig2$lat=as.integer(tableSQL_Fig1$lat)
  
  tableSQL_Fig3=dbGetQuery(oiseaux_bd, "SELECT lat, ordre, count(ordre) AS abondance
             FROM principale
             LEFT JOIN site ON principale.site_id = site.site_id
             LEFT JOIN taxonomie ON principale.valid_scientific_name = taxonomie.valid_scientific_name
             WHERE ordre in ('Passeriformes')
             GROUP BY ordre, lat  " )
  
  tableSQL_Fig4=dbGetQuery(oiseaux_bd, "SELECT CONCAT(strftime('%Y', date_obs),'-' ,strftime('%m', date_obs)) AS Date , ordre, COUNT(ordre) AS abondance 
              FROM principale
              LEFT JOIN temps ON principale.id_date = temps.id_date
              LEFT JOIN taxonomie ON principale.valid_scientific_name = taxonomie.valid_scientific_name
              WHERE ordre in ('Passeriformes')
              GROUP BY ordre, strftime('%Y', date_obs),strftime('%m', date_obs)" )
  
  liste_table_SQL=list(tableSQL_Fig1, tableSQL_Fig2, tableSQL_Fig3, tableSQL_Fig4)
  #Nous déconnecte de la base de données oiseaux.db pour permettre 
  #l'accès à un autre utilisateur
  dbDisconnect(oiseaux_bd)
  
  
  return(liste_table_SQL)
}