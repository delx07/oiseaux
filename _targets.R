library(targets)
library(dplyr)
library(RSQLite)
library(DBI)
library(lubridate)
library(parsedate)
library(rmarkdown)
library(rticles)
library(tinytex)
library(tarchetypes)
library(ggplot2)

source("ScriptsR/Lectures_donnees_multiples.R")
source("ScriptsR/Creation_tables_oiseaux.R")
source("ScriptsR/Injection.R")
source("ScriptsR/DemandeSQL.R")
source("ScriptsR/Analyse_oiseaux.R")

list(
  tar_target(
    name = donnees_oiseaux, #nom dataframe
    command = Lectures_donnees_m("Données") # Lecture des données
  ), 
  tar_target(
    name = creation, #retour pour faire la liaison avec le target suivant
    command = Creation_table_oiseaux(donnees_oiseaux) # Création des tables
  ),
  tar_target(
    name = injection, #retour des tests après injection
    command = injection(donnees_oiseaux, creation) # Injection des données
  ),
  tar_target(
    name = demande_table, #retour des tableau de données pour répondre aux questions
    command = Demande_SQL(injection) # demande des données de la bd pour faire les 
  ),
  tar_target(
    name = analyse, #retour des tableau de données pour répondre aux questions
    command = Analyse_oiseaux(demande_table) # demande des données de la bd pour faire les 
  ),
  tar_render(
    name = rapport, # Cible du rapport
    path = "Rapport/Rapport.Rmd" # Le path du rapport à renderiser
  )
)
