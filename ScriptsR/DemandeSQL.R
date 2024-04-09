Demande_SQL=function(liste_table){
  #Monte le nom avec le working directory pour se connecter à la base de données
  d=getwd()
  n="oiseaux.db"
  z=paste(d,n)
  #Ouvre la oiseaux_bd à la base de donnée nommée oiseaux.db par l'objet oiseaux_db
  oiseaux_bd = dbConnect(RSQLite::SQLite(), dbname=z)
  
  tableSQL=dbGetQuery(oiseaux_bd, "SELECT Lat, date_obs, valid_scientific_name 
             FROM principale
             LEFT JOIN site ON principale.site_id = site.site_id
             LEFT JOIN temps ON principale.id_date = temps.id_date" )
  
  #Nous déconnecte de la base de données oiseaux.db pour permettre 
  #l'accès à un autre utilisateur
  dbDisconnect(oiseaux_bd)
  
  
  return(tableSQL)
}