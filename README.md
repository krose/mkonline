
<!-- README.md is generated from README.Rmd. Please edit that file -->
wattsight
=========

This is an R wrapper for the Wattsight API.

The package is still in early beta.

Before you start to use the wattsight package I recommend that you save your username and password in a .Renviron file like this:


    WS_USER = "<user-name>"
    WS_PASSWORD = "<user-password>"

It is not recommended to write scripts with your username and password. Also, make sure to use an unimportant password when using the API.

There are two main functions:

-   ws\_list\_files: This function downloads a list of available documents for download.
-   ws\_download\_file: This function downloads a file based on the key (ws\_file) and the area (ws\_area) listed in the returned object from the function ws\_list\_files.

Installation
------------

You can install wattsight from github with:

``` r
# install.packages("devtools")
devtools::install_github("krose/wattsight")
```

Load packages
-------------

First, load a few packages.

``` r

library(wattsight)
library(tidyverse)
```

List all files
--------------

If you only want to see the files accessible to you, then set param only\_accessible to TRUE.

``` r

ws_list_files(only_accessible = FALSE) %>% glimpse()
#> Observations: 1,605
#> Variables: 7
#> $ access   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS...
#> $ category <chr> "CO2", "Coal and Freight", "Coal and Freight", "Coal ...
#> $ filename <chr> "CO2 Price Forecast", "Coal Freight Price Forecast Pe...
#> $ areaname <chr> "Combined, all 27 countries + Norway", "Amsterdam - R...
#> $ key      <chr> "CO2_PRI_F", "COA_PRI_PERRET_Q_F", "COA_PRI_PERRET_Y_...
#> $ area     <chr> "25", "ara", "ara", "ara", "ara", "ara", "ara", "ara"...
#> $ updated  <dttm> 2018-02-23 07:25:00, 2018-02-25 19:58:00, 2018-02-25...
```

Download file
-------------

Get the params from the ws\_list\_files function.

``` r

ws_download_file(key = "PRO_WND_H_N", area = "np") %>% glimpse()
#> Observations: 61,344
#> Variables: 17
#> $ date                            <dttm> 2014-01-01 00:00:00, 2014-01-...
#> $ pro_npa_wnd_normal_mk02_mwh_h_n <dbl> 4235.0, 4218.5, 4184.5, 4146.0...
#> $ pro_se_wnd_normal_mk02_mwh_h_n  <dbl> 1739.6, 1722.4, 1702.4, 1685.8...
#> $ pro_no_wnd_normal_mk02_mwh_h_n  <dbl> 347.9, 347.3, 347.6, 346.3, 34...
#> $ pro_dk_wnd_normal_mk02_mwh_h_n  <dbl> 1950.8, 1955.0, 1940.5, 1922.2...
#> $ pro_dk1_wnd_normal_mk02_mwh_h_n <dbl> 1514.7, 1519.9, 1508.7, 1494.8...
#> $ pro_dk2_wnd_normal_mk02_mwh_h_n <dbl> 436.1, 435.2, 431.8, 427.4, 42...
#> $ pro_fi_wnd_normal_mk02_mwh_h_n  <dbl> 196.7, 193.9, 194.0, 191.7, 18...
#> $ pro_se1_wnd_normal_mk02_mwh_h_n <dbl> 129.5, 127.1, 126.3, 125.5, 12...
#> $ pro_se2_wnd_normal_mk02_mwh_h_n <dbl> 454.8, 448.9, 444.4, 439.3, 43...
#> $ pro_se3_wnd_normal_mk02_mwh_h_n <dbl> 664.4, 658.7, 651.5, 646.7, 64...
#> $ pro_se4_wnd_normal_mk02_mwh_h_n <dbl> 490.9, 487.6, 480.2, 474.3, 46...
#> $ pro_no1_wnd_normal_mk02_mwh_h_n <chr> NA, NA, NA, NA, NA, NA, NA, NA...
#> $ pro_no2_wnd_normal_mk02_mwh_h_n <dbl> 123.6, 124.3, 123.5, 122.2, 12...
#> $ pro_no3_wnd_normal_mk02_mwh_h_n <dbl> 146.0, 145.1, 146.2, 145.7, 14...
#> $ pro_no4_wnd_normal_mk02_mwh_h_n <dbl> 78.3, 77.9, 77.9, 78.4, 78.7, ...
#> $ pro_no5_wnd_normal_mk02_mwh_h_n <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
```
