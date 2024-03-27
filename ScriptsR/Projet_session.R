library(dplyr)
library(RSQLite)
library(DBI)
library(lubridate)
library(parsedate)
library(rmarkdown)
library(targets)
#Choisir votre work directory avec les donnees et les scripts, et 
#même chose pour les sources
source("ScriptsR/Lectures_donnees_multiples.R")
source("ScriptsR/Creation_tables_oiseaux.R")


#Lectures des données pour en faire un data frame
data_oiseaux=Lectures_donnees_m("Données")


#Monte le nom avec le working directory pour se connecter à la base de données
d=getwd()
n="oiseaux.db"
z=paste(d,n)
#Ouvre la connection à la base de donnée nommée oiseaux.db par l'objet oiseaux_db
oiseaux_bd = dbConnect(RSQLite::SQLite(), dbname=z)

#Séparation en tableaux, formation des tables sql et les rempli.
#Les tableaux vont être listé dans liste_table pour débugging
liste_table=Creation_table_oiseaux(data_oiseaux, oiseaux_bd)

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
dbSendQuery(oiseaux_bd, "DROP TABLE temps")
dbSendQuery(oiseaux_bd, "DROP TABLE site")
dbSendQuery(oiseaux_bd, "DROP TABLE taxonomie")
dbSendQuery(oiseaux_bd, "DROP TABLE principale")

#Nous déconnecte de la base de données oiseaux.db pour permettre 
#l'accès à un autre utilisateur
dbDisconnect(oiseaux_bd)
