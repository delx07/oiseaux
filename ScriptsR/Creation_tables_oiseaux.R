Creation_table_oiseaux= function(fichier){
  
  #Monte le nom avec le working directory pour se connecter à la base de données
  d=getwd()
  n="oiseaux.db"
  z=paste(d,n)
  #Ouvre la oiseaux_bd à la base de donnée nommée oiseaux.db par l'objet oiseaux_db
  oiseaux_bd = dbConnect(RSQLite::SQLite(), dbname=z)
  
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
  
  
  #Crée la table temps sous forme d'un char pour être utilisé dans la fonction dbSendQuery
  creer_temps = "CREATE TABLE temps (
        id_date       INTEGER PRIMARY KEY AUTOINCREMENT,
        time_start    TIME,
        time_finish   TIME,
        date_obs      DATE
    );"
  
  #Envoie la demande à RSQLite pour la création de la table temps par l'objet 
  #oiseaux_bd qui nous lie à la base de donnée oiseaux.db
  dbSendQuery(oiseaux_bd, creer_temps)
  
  #Crée la table taxonomie sous forme d'un char pour être utilisé dans la fonction dbSendQuery
  creer_taxonomie = "CREATE TABLE taxonomie (
        valid_scientific_name     VARCHAR(80),
        rank                      VARCHAR(80),
        kingdom                   VARCHAR(80),
        phylum                    VARCHAR(80),
        class                     VARCHAR(80),
        ordre                     VARCHAR(80),
        family                    VARCHAR(80),
        genus                     VARCHAR(80),
        species                   VARCHAR(80),
        PRIMARY KEY (valid_scientific_name)
        
    );"
  
  #Envoie la demande à RSQLite pour la création de la table taxonomie par l'objet 
  #oiseaux_bd qui nous lie à la base de donnée oiseaux.db
  dbSendQuery(oiseaux_bd, creer_taxonomie)
  
  #Crée la table site sous forme d'un char pour être utilisé dans la fonction dbSendQuery
  creer_site = "CREATE TABLE site (
        site_id           INTEGER,
        lat               DOUBLE,
        georef            CHAR(8),
        PRIMARY KEY (site_id,lat,georef)
    );"
  
  #Envoie la demande à RSQLite pour la création de la table principale par l'objet 
  #oiseaux_bd qui nous lie à la base de donnée oiseaux.db
  dbSendQuery(oiseaux_bd, creer_site)
  
  #Crée la table principale sous forme d'un char pour être utilisé dans la fonction dbSendQuery
  creer_principale = "CREATE TABLE principale (
        n_index                 INTEGER PRIMARY KEY AUTOINCREMENT,
        variable                VARCHAR(20),
        time_obs                TIME,
        valid_scientific_name   VARCHAR(80),
        site_id                 INTEGER,
        id_date                  INTEGER,
        FOREIGN KEY (valid_scientific_name) REFERENCES taxonomie(valid_scientific_name),
        FOREIGN KEY (site_id) REFERENCES site(site_id),
        FOREIGN KEY (id_date) REFERENCES temps(id_date)
    );"
  
  #Envoie la demande à RSQLite pour la création de la table principale par l'objet 
  #oiseaux_bd qui nous lie à la base de donnée oiseaux.db
  dbSendQuery(oiseaux_bd, creer_principale)
  
  #écriture des tables en injectant les données de nos dataframe R
  dbWriteTable(oiseaux_bd, append=TRUE, name="site", value=data_site, row.names=FALSE)
  dbWriteTable(oiseaux_bd, append=TRUE, name="taxonomie", value=data_taxonomie, row.names=FALSE)
  dbWriteTable(oiseaux_bd, append=TRUE, name="temps", value=data_temps, row.names=FALSE)
  
  #ajout de id_obs à la table fichier pour ensuite faire le lien dans data_principale et la table principale
  id_merge=dbGetQuery(oiseaux_bd, "SELECT * FROM temps")
  fichier = left_join(id_merge, fichier, by=c("time_start","time_finish","date_obs"))
  
  data_principale=fichier[ , c("variable", "time_obs","site_id","valid_scientific_name", "id_date")]
  
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
  
  #débugging
  #dbSendQuery(oiseaux_bd, "DROP TABLE temps")
  #dbSendQuery(oiseaux_bd, "DROP TABLE site")
  #dbSendQuery(oiseaux_bd, "DROP TABLE taxonomie")
  #dbSendQuery(oiseaux_bd, "DROP TABLE principale")
  
  #Nous déconnecte de la base de données oiseaux.db pour permettre 
  #l'accès à un autre utilisateur
  dbDisconnect(oiseaux_bd)
  
  #liste pour le retour des tableaux à des fin de débbuging
  liste_test=list(data_temps, data_site, data_taxonomie, data_principale, fichier, test2, test3, test4, test5)
 
  return(liste_test)
}