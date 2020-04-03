setwd("~/git/AIRBNB-cognitivo/")
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

online = TRUE
if(online){
  calendario_zip <-  read_csv("https://p-def2.pcloud.com/DLZxWsaNjZOyHFDfZQIPHZZC43na7Z2ZZ8yLZZdxBalZKFZsFZr0ZzAr7qoPaxkVhgsLqTuHLSyeXGC8k/calendar_zip.csv")
  listings_zip <- read.csv("https://p-def1.pcloud.com/cfZ2jwaNjZVfsFDfZQIPHZZHb3na7Z2ZZ8yLZZCfLMFZtZvJZQZf0ZLJZKFZI7ZNFZjJZfFZ30ZQ0Z15ZqJZoHjyYwwOJsyNJrzzV4Wxgh84h7FX/listings_zip.csv")
  listings <- read_csv("https://p-def4.pcloud.com/cfZzJENNjZL665DfZQIPHZZRm3na7Z2ZZ8yLZZ0OBSZC7ZWFZ15ZQFZs0Z6JZiJZe0ZQkZk5Z35ZGZ8JZppZ3k5TOnGSNHLxzEgoQhoDAJfNmh7y/listings.csv")
  review_zip <-read_csv("https://p-def5.pcloud.com/cfZJCAaNjZEj0pDfZQIPHZZzn3na7Z2ZZ8yLZZbvUcJZQFZHZxVZqFZBJZSFZa5ZvFZv7ZgkZrJZC7Zz0ZW0ZUp4UW6kq8kbRRs0sUrzLqme6nmTX/reviews_zip.csv")
  review <- read_csv("https://p-def6.pcloud.com/cfZpD6NNjZrUt5DfZQIPHZZ0h3na7Z2ZZ8yLZZu1n1Z7pZNFZ0pZoJZdFZQ0ZQJZF0Z4JZ0Z90ZIJZg5ZwVZMzbKopwx06XVoBVdKmPP5mdS1jMX/reviews.csv")
  neighbourhoods <- read_csv("https://c155.pcloud.com/dHZtPSMlSZxxq5DfZQIPHZZOw3na7Z2ZZ8yLZkZOVDTkZ0OTIqQ3Op750eJ1BMgIB4bvPs3Gy/neighbourhoods.csv")
}else{
  calendar_zip <- read_csv("dados/calendar_zip.csv") # --> minimum_nights e maximum_nights noites NA's:7
  listings_zip <- read_csv("dados/listings_zip.csv")
  listings <- read_csv("dados/listings.csv") # name = 58 NA's | host_name = 11 NA's | neighbourhood_group = NULL | neighbourhood_group, neighbourhood_group = 14.592
  reviews_zip <- read_csv("dados/reviews_zip.csv") # --> NA's:0
  reviews <- read_csv("dados/reviews.csv") # --> NA's:0
  neighbourhoods <- read_csv("dados/neighbourhoods.csv") # --> neighbourhood_group: NA's:160 todas
}




####  Valores Nulos  ####
summary(calendar_zip)
#colnames(calendar_zip) <- c("id", "data", "avaliacao", "preco", "ajuste_do_preco", "minimo_de_noites", "maximo_noites")

########################################################################################################
summary(listings_zip)
#source("renomear_dataset_principal.R", encoding = "UTF-8")
listings_zip_nulas <- listings_zip[,pegarVariaveisNulas(listings_zip)]
listings_zip_nao_nulas <- listings_zip[,pegarVariaveisNaoNulas(listings_zip)]

########################################################################################################
#nomes_listagens <- c("id_listagem", "nome", "id_host", "nome_host", "grupo_de_vizinhanca", "vizinhanca", "latitude", "longitude",
#  "tipo_de_sala", "preco", "minimo_de_noites", "numero_de_avaliacoes", "ultima_avaliacao",
#  "avaliacoes_por_mes", "contagem_calculada_de_listagens_de_host", "disponibilidade_365")
#colnames(listings) <- nomes_listagens
nrow(listings %>% filter(is.na(reviews_per_month)))

########################################################################################################
summary(reviews_zip)
#colnames(reviews_zip) <- c("id_listagem", "id_avaliacao", "data", "id_avaliacao", "nome_avaliacao", "comentarios")

########################################################################################################
summary(reviews)
#colnames(reviews) <- c("id_listagem", "data")

########################################################################################################
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

