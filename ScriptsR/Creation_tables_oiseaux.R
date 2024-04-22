Creation_table_oiseaux= function(fichier){
  #Ouvre la oiseaux_bd à la base de donnée nommée oiseaux.db par l'objet oiseaux_db
  oiseaux_bd = dbConnect(RSQLite::SQLite(), dbname="oiseaux.db")
  
  #Crée la table temps sous forme d'un char pour être utilisé dans la fonction dbSendQuery
  creer_temps = "CREATE TABLE if NOT EXISTS temps (
        id_date       INTEGER PRIMARY KEY AUTOINCREMENT,
        time_start    TIME,
        time_finish   TIME,
        date_obs      DATE
    );"
  
  #Envoie la demande à RSQLite pour la création de la table temps par l'objet 
  #oiseaux_bd qui nous lie à la base de donnée oiseaux.db
  dbSendQuery(oiseaux_bd, creer_temps)
  
  #Crée la table taxonomie sous forme d'un char pour être utilisé dans la fonction dbSendQuery
  creer_taxonomie = "CREATE TABLE if NOT EXISTS taxonomie (
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
  creer_site = "CREATE TABLE if NOT EXISTS site (
        site_id           INTEGER,
        lat               DOUBLE,
        georef            CHAR(8),
        PRIMARY KEY (site_id,lat,georef)
    );"
  
  #Envoie la demande à RSQLite pour la création de la table principale par l'objet 
  #oiseaux_bd qui nous lie à la base de donnée oiseaux.db
  dbSendQuery(oiseaux_bd, creer_site)
  
  #Crée la table principale sous forme d'un char pour être utilisé dans la fonction dbSendQuery
  creer_principale = "CREATE TABLE if NOT EXISTS principale (
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
  
  #Nous déconnecte de la base de données oiseaux.db pour permettre 
  #l'accès à un autre utilisateur
  dbDisconnect(oiseaux_bd)
  
  return()
}