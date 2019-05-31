# nethoser

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

Networks for [webhoser](https://webhoser.john-coene.com/).

Build various graphs from [webhoser](https://webhoser.john-coene.com/) data. Connect entities to one another, or to media outlets, and more.

## Installation

``` r
# install.packages(remotes)
remotes::install_github("news-r/nethoser")
```

## Examples

```r
library(nethoser)

data("webhoser")

# make network
webhoser %>%
  net_con(thread.site, entities.persons) %>% 
  net_vis()
```

See the [website](http://nethoser.john-coene.com) for examples.
