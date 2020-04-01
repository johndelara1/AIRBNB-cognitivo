setwd("~/git/airbnb")
library(readr)
library(tibble)
library(dplyr)

#### Funcoes ####
pegarVariaveisNaoNulas <- function(x){
  nomes  <- names(x)
  variaveisSemValoresNulos <- c()
  for (i in 1:length(nomes)) {
    colunaComValoresNulos <- any(is.na(x[,i]))
    if(!colunaComValoresNulos){
      variaveisSemValoresNulos <- c(variaveisSemValoresNulos, nomes[i])
    }
  }
  return(variaveisSemValoresNulos)
}
pegarVariaveisNulas <- function(x){
  nomes  <- names(x)
  variaveisSemValoresNulos <- c()
  for (i in 1:length(nomes)) {
    colunaComValoresNulos <- any(is.na(x[,i]))
    if(colunaComValoresNulos){
      variaveisSemValoresNulos <- c(variaveisSemValoresNulos, nomes[i])
    }
  }
  return(variaveisSemValoresNulos)
}

####  Valores Nulos  ####
calendar_zip <- read_csv("dados/calendar_zip.csv") # --> minimum_nights e maximum_nights noites NA's:7
summary(calendar_zip)
#colnames(calendar_zip) <- c("id", "data", "avaliacao", "preco", "ajuste_do_preco", "minimo_de_noites", "maximo_noites")

########################################################################################################
listings_zip <- read_csv("dados/listings_zip.csv")
summary(listings_zip)
#source("renomear_dataset_principal.R", encoding = "UTF-8")
listings_zip_nulas <- listings_zip[,pegarVariaveisNulas(listings_zip)]
listings_zip_nao_nulas <- listings_zip[,pegarVariaveisNaoNulas(listings_zip)]

########################################################################################################
listings <- read_csv("dados/listings.csv") # name = 58 NA's | host_name = 11 NA's | neighbourhood_group = NULL | neighbourhood_group, neighbourhood_group = 14.592
#nomes_listagens <- c("id_listagem", "nome", "id_host", "nome_host", "grupo_de_vizinhanca", "vizinhanca", "latitude", "longitude",
#  "tipo_de_sala", "preco", "minimo_de_noites", "numero_de_avaliacoes", "ultima_avaliacao",
#  "avaliacoes_por_mes", "contagem_calculada_de_listagens_de_host", "disponibilidade_365")
#colnames(listings) <- nomes_listagens
nrow(listings %>% filter(is.na(reviews_per_month)))

########################################################################################################
reviews_zip <- read_csv("dados/reviews_zip.csv") # --> NA's:0
summary(reviews_zip)
#colnames(reviews_zip) <- c("id_listagem", "id_avaliacao", "data", "id_avaliacao", "nome_avaliacao", "comentarios")

########################################################################################################
reviews <- read_csv("dados/reviews.csv") # --> NA's:0
summary(reviews)
#colnames(reviews) <- c("id_listagem", "data")

########################################################################################################
neighbourhoods <- read_csv("dados/neighbourhoods.csv") # --> neighbourhood_group: NA's:160
summary(neighbourhoods)
# colnames(neighbourhoods) <- c("grupo_de_vizinhos", "vizinhanca")


############# DONE ###############

#### Higenização ####
higienizar_listings_zip <- listings_zip[,pegarVariaveisNulas(listings_zip)]
glimpse(higienizar_listings_zip)
summary(listings_zip$pontuacao_de_avaliacao)
# listings
higienizar_listings <- listings[,pegarVariaveisNulas(listings)]
pegarVariaveisNaoNulas(listings)
summary(listings)

