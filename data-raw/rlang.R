library(webhoser)

token <- wh_token("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")

webhoser <- token %>%
  wh_news(
    '"R$" AND ("programming$" OR "pacakge$") is_first:true language:english site_type:news'
  ) %>%
  wh_paginate(2) %>%
  wh_collect(TRUE)

usethis::use_data(webhoser, overwrite = TRUE)
