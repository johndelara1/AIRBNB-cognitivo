setwd("~/git/AIRBNB-cognitivo/")
library(readr)        # GERAR CSV
library(tibble)       # VIZUALIZAR OS TIPOS DE DADOS
library(dplyr)        # Filtragens
library(randomForest) # MODELO RANDONFOREST
library(rpart)        # ÁRVORES DE DECISÃO
library(ggplot2)      # GRÁFICOS
library(caret)        # MODELOS DIVERSOS
# https://topepo.github.io/caret/visualizations.html
# https://rpubs.com/samkaris/rfvsrpart

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
  calendario_zip <-  read_csv("~/pCloudDrive/Profissional/ciencia-de-dados/cognitivo/dados/calendar_zip.csv")
  listings_zip <- read.csv("~/pCloudDrive/Profissional/ciencia-de-dados/cognitivo/dados/listings_zip.csv")
  listings <- read_csv("~/pCloudDrive/Profissional/ciencia-de-dados/cognitivo/dados/listings.csv")
  review_zip <-read_csv("~/pCloudDrive/Profissional/ciencia-de-dados/cognitivo/dados/reviews_zip.csv")
  review <- read_csv("~/pCloudDrive/Profissional/ciencia-de-dados/cognitivo/dados/reviews.csv")
  neighbourhoods <- read_csv("~/pCloudDrive/Profissional/ciencia-de-dados/cognitivo/dados/neighbourhoods.csv")
}else{
  calendar_zip <- read_csv("dados/calendar_zip.csv") # --> minimum_nights e maximum_nights noites NA's:7
  listings_zip <- read_csv("dados/listings_zip.csv") # -->  
  listings <- read_csv("dados/listings.csv") # name = 58 NA's | host_name = 11 NA's | neighbourhood_group = NULL | neighbourhood_group, neighbourhood_group = 14.592
  reviews_zip <- read_csv("dados/reviews_zip.csv") # --> NA's:0
  reviews <- read_csv("dados/reviews.csv") # --> NA's:0
  neighbourhoods <- read_csv("dados/neighbourhoods.csv") # --> neighbourhood_group: NA's:160 todas
}

#### Análise de Valores Nulos ####
summary(calendar_zip)   # minimum_nights e maximum_nights noites NA's:7
summary(listings_zip)   # Avaliar variáveis respostas para o modelo
summary(listings)       # name = 58 NA's | host_name = 11 NA's | neighbourhood_group = NULL | neighbourhood_group, neighbourhood_group = 14.592
summary(reviews_zip)    # --> NA's:0
summary(reviews)        # --> NA's:0
summary(neighbourhoods) # neighbourhood_group: NA's:160 todas

variaveis_numericas <- c("id","scrape_id","host_id","latitude","longitude","accommodates","guests_included",
                         "minimum_nights","maximum_nights","minimum_minimum_nights","maximum_minimum_nights",
                         "minimum_maximum_nights","maximum_maximum_nights","minimum_nights_avg_ntm",
                         "maximum_nights_avg_ntm","availability_30","availability_60","availability_90",
                         "availability_365","number_of_reviews","number_of_reviews_ltm",
                         "calculated_host_listings_count","calculated_host_listings_count_entire_homes",
                         "calculated_host_listings_count_private_rooms",
                         "calculated_host_listings_count_shared_rooms")


# #### Estratégia de modelagem ####
nrow(listings_zip %>% filter(is.na(review_scores_rating)))
sem_na_listings_zip <- listings_zip[,pegarVariaveisNaoNulas(listings_zip)]
numericas_listings <- sem_na_listings_zip[,variaveis_numericas]

numericas_listings$review_scores_rating <- listings_zip$review_scores_rating
train <- numericas_listings %>% filter(!is.na(review_scores_rating))
test <- numericas_listings %>% filter(is.na(review_scores_rating))
unique(train$review_scores_rating)

#### Modelo de Regressão Linear ####
modelo <- lm(review_scores_rating ~ ., data = train)
summary(modelo)
previsao1 <- predict(modelo, train)
plot(modelo, uniform=TRUE,
     main="Regression Tree for Mileage ")

#### Modelo de rpart(Árvores de Decisões) ####
modelo_rp = rpart(review_scores_rating ~ ., 
                  method="class",
                  data = train,
                  control = rpart.control( cp = .000999999999999999)) 
# plot(modelo_rp, uniform=TRUE, main="Regression Tree for Mileage ")
# text(modelo_rp, use.n=TRUE, all=TRUE, cex=.8)
pred_rp[1] <- predict(modelo_rp, test)

# Utilizando RPART
RpartModel_fit <- train(review_scores_rating ~., method = "rpart", data = train)
Validation_pred <- predict(RpartModel_fit, test)
#plot(RpartModel_fit, uniform=TRUE, main="Regression Tree for Mileage ")

#### Modelo de RandonForest(Floresta Aleatória) ####
modelo_rf <- randomForest(review_scores_rating ~ . , 
                      data = train, 
                      method="class",
                      ntree = 600,
                      nodesize = 50,
                      importance = TRUE)
summary(modelo_rf)
#Variáveis mais relevantes Importância das feautures
importancia_pred <- as.data.frame(importance(modelo_rf, scale = TRUE))
importancia_pred <- rownames_to_column(importancia_pred, var = "variable")
p1 <- ggplot(data = importancia_pred, aes(x = reorder(variable, `%IncMSE`),
                                          y = `%IncMSE`,
                                          fill = `%IncMSE`)) +
  labs(x = "variable", title = "Redução do MSE") +
  geom_col() +
  coord_flip() +
  theme_bw() +
  theme(legend.position = "bottom")

p2 <- ggplot(data = importancia_pred, aes(x = reorder(variable, IncNodePurity),
                                          y = IncNodePurity,
                                          fill = IncNodePurity)) +
  labs(x = "variable", title = "Redução de pureza") +
  geom_col() +
  coord_flip() +
  theme_bw() +
  theme(legend.position = "bottom")

library(cowplot)
cowplot::plot_grid(p1, p2)




####### factor #######
# $ listing_url                                  <fct> https…
# $ last_scraped                                 <fct> 2020-…
# $ name                                         <fct> "Very…
# $ summary                                      <fct> "Pls …
# $ space                                        <fct> "- la…
# $ description                                  <fct> "Pls …
# $ experiences_offered                          <fct> none,…
# $ neighborhood_overview                        <fct> "This…
# $ notes                                        <fct> "", "…
# $ transit                                      <fct> "Exce…
# $ access                                       <fct> "The …
# $ interaction                                  <fct> "I wi…
# $ house_rules                                  <fct> "Plea…
# $ picture_url                                  <fct> "http…
# $ host_url                                     <fct> https…
# $ host_name                                    <fct> Matth…
# $ host_since                                   <fct> 2010-…
# $ host_location                                <fct> "Rio …
# $ host_about                                   <fct> "I  a…
# $ host_response_time                           <fct> withi…
# $ host_response_rate                           <fct> 100%,…
# $ host_acceptance_rate                         <fct> 99%, …
# $ host_is_superhost                            <fct> t, f,…
# $ host_thumbnail_url                           <fct> https…
# $ host_picture_url                             <fct> https…
# $ host_neighbourhood                           <fct> Copac…
# $ host_verifications                           <fct> "['em…
# $ host_has_profile_pic                         <fct> t, t,…
# $ host_identity_verified                       <fct> t, t,…
# $ street                                       <fct> "Rio …
# $ neighbourhood                                <fct> Copac…
# $ neighbourhood_cleansed                       <fct> Copac…
# $ city                                         <fct> Rio d…
# $ state                                        <fct> Rio d…
# $ zipcode                                      <fct> 22020…
# $ market                                       <fct> Rio D…
# $ smart_location                               <fct> "Rio …
# $ country_code                                 <fct> BR, B…
# $ country                                      <fct> Brazi…
# $ is_location_exact                            <fct> t, t,…
# $ property_type                                <fct> Condo…
# $ room_type                                    <fct> Entir…
# $ bed_type                                     <fct> Real …
# $ amenities                                    <fct> "{TV,…
# $ price                                        <fct> "$289…
# $ weekly_price                                 <fct> "", "…
# $ monthly_price                                <fct> "", "…
# $ security_deposit                             <fct> "$0.0…
# $ cleaning_fee                                 <fct> $300.…
# $ extra_people                                 <fct> $73.0…
# $ calendar_updated                             <fct> 3 wee…
# $ has_availability                             <fct> t, t,…
# $ calendar_last_scraped                        <fct> 2020-…
# $ first_review                                 <fct> 2010-…
# $ last_review                                  <fct> 2020-…
# $ requires_license                             <fct> f, f,…
# $ license                                      <fct> , , ,…
# $ instant_bookable                             <fct> t, f,…
# $ is_business_travel_ready                     <fct> f, f,…
# $ cancellation_policy                          <fct> stric…
# $ require_guest_profile_picture                <fct> f, f,…
# $ require_guest_phone_verification             <fct> f, f,… 


############# variaveis separadas em fator e numericas do listings_zip  ###############
#transformar_em_variaveis_numericas <-
#  c("listing_url","last_scraped","name","summary",
#    "space","description","experiences_offered","neighborhood_overview","notes","transit",
#    "access","interaction","house_rules","picture_url","host_url","host_name","host_since","host_location",
#    "host_about","host_response_time","host_response_rate","host_acceptance_rate",
#    "host_is_superhost","host_thumbnail_url","host_picture_url","host_neighbourhood",
#    "host_verifications","host_has_profile_pic","host_identity_verified","street",
#    "neighbourhood","neighbourhood_cleansed","city","state","zipcode","market","smart_location","country_code",
#    "country","is_location_exact","property_type","room_type","bed_type","amenities","price","weekly_price",
#    "monthly_price","security_deposit","cleaning_fee","extra_people",
#    "calendar_updated","has_availability","calendar_last_scraped","first_review",
#    "last_review","requires_license","license","instant_bookable","is_business_travel_ready","cancellation_policy",
#    "require_guest_profile_picture","require_guest_phone_verification")
#
#variaveis_numericas <- c("id",
#                         "scrape_id",
#                         "thumbnail_url",
#                         "medium_url",
#                         "xl_picture_url",
#                         "host_id",
#                         "host_listings_count",
#                         "host_total_listings_count",
#                         "neighbourhood_group_cleansed",
#                         "latitude",
#                         "longitude",
#                         "accommodates",
#                         "bathrooms",
#                         "bedrooms",
#                         "beds",
#                         "square_feet",
#                         "guests_included",
#                         "minimum_nights",
#                         "maximum_nights",
#                         "minimum_minimum_nights",
#                         "maximum_minimum_nights",
#                         "minimum_maximum_nights",
#                         "maximum_maximum_nights",
#                         "minimum_nights_avg_ntm",
#                         "maximum_nights_avg_ntm",
#                         "availability_30",
#                         "availability_60",
#                         "availability_90",
#                         "availability_365",
#                         "number_of_reviews",
#                         "number_of_reviews_ltm",
#                         "review_scores_rating",
#                         "review_scores_accuracy",
#                         "review_scores_cleanliness",
#                         "review_scores_checkin",
#                         "review_scores_communication",
#                         "review_scores_location",
#                         "review_scores_value",
#                         "jurisdiction_names",
#                         "calculated_host_listings_count",
#                         "calculated_host_listings_count_entire_homes",
#                         "calculated_host_listings_count_private_rooms",
#                         "calculated_host_listings_count_shared_rooms",
#                         "reviews_per_month")
