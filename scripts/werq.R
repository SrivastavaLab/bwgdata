library(jqr)
library(dplyr)
library(bwgdata)

bwg_auth()

bwg_get("species", NULL)

## why on earth is this broken!?!????
trts <- bwg_get("species", list(traits = "true"))

View(trts)
trts %>% 
  select(success)

trts %>% 
  index 

## just obtain the trait table
spp <- trts %>% 
  jsonlite::fromJSON(flatten = TRUE) %>% 
  .[["results"]] %>% 
  # lapply(names)
  .[["species"]]

library(dplyr)
library(tidyr)

spp %>% 
  dplyr::select(bwg_name) %>% 
  separate(into = c("order", "num"), bwg_name) %>% 
  mutate(num = as.numeric(num)) %>% 
  group_by(order) %>% 
  summarize(highest = max(num, na.rm = TRUE)) %>% 
  readr::write_csv("highest_group_codes.csv")

spp %>% 
  dplyr::select(bwg_name) %>% 
  filter(grepl("Coleoptera.*", bwg_name))
  

trts %>% 
  select(results) %>% 
  

trts %>%
  select(results, sp = `.species_id[]`) 

x <- '{"user":"stedolan","titles":["JQ Primer", "More JQ"]}'
jq(x, '{user, title: .titles[]}')


# bromeliads? -----------------------------------------

bwg_get("datasets")

bwg_get("visits")

bwg_get("bromeliads", opts = list(visit_id = 21))

bwg_get("bromeliads")

bwg_get("matrix",opts = list(dataset_id = 41) )

bwgtools::get_bwg_names()


# parsing bromeliad -----------------------------------


# mapping ---------------------------------------------

library(ggmap)

SAm <- c(left = -120, bottom = -56, right = -34, top = 30)
map <- get_stamenmap(SAm, zoom = 5, maptype = "watercolor")
ggmap(map)

dats <- bwg_get("datasets")

locs <- dats %>% 
  filter(!grepl("Test.*", x = name)) %>% 
  select(location, lat, lng) %>% 
  group_by(location, lat, lng) %>% 
  tally %>% 
  ungroup() %>% 
  mutate(lat = as.numeric(lat),
         lng = as.numeric(lng))


ggmap(map) + geom_point(aes(x = lng, y = lat, size = n),
                        alpha = 0.4,
                        data = locs) 


