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
source("_targets.R")
#Lectures des données pour en faire un data frame
data_oiseaux=Lectures_donnees_m("Données")


#Séparation en tableaux, formation des tables sql et les rempli.
#Les tableaux vont être listé dans liste_table pour débugging
liste_table=Creation_table_oiseaux(data_oiseaux)



