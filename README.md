This is an R wrapper for the MKonline API.

The package is still in early beta.

Make sure to use an unimportant password when using the API.

There are two main functions:

-   mk\_list\_files: This function downloads a list of available documents for download.
-   mk\_download\_file: This function downloads a file based on the key (mk\_file) and the area (mk\_area) listed in the returned object from the function mk\_list\_files.

First, load a few packages.

``` r
library(mkonline)
library(magrittr)
```

List the available files:

``` r
mk_list_files(mk_user = mk_user, mk_password = mk_password, only_accessible = FALSE, time_zone = "GMT") %>% head()
```

    ##   access         category                                     filename
    ## 1  false Coal and Freight Coal Freight Price Forecast Perret Quarterly
    ## 2  false Coal and Freight    Coal Freight Price Forecast Perret Yearly
    ## 3  false Coal and Freight               Coal Freight Spot Price Perret
    ## 4  false Coal and Freight                     Coal inventories monthly
    ## 5  false Coal and Freight                      Coal inventories weekly
    ## 6  false Coal and Freight                 Coal Replacement Cost Perret
    ##                          areaname                     key area
    ## 1 Amsterdam - Rotterdam - Antwerp      COA_PRI_PERRET_Q_F  ara
    ## 2 Amsterdam - Rotterdam - Antwerp      COA_PRI_PERRET_Y_F  ara
    ## 3 Amsterdam - Rotterdam - Antwerp      COA_PRI_PERRET_D_A  ara
    ## 4 Amsterdam - Rotterdam - Antwerp      COA_INV_PERRET_M_S  ara
    ## 5 Amsterdam - Rotterdam - Antwerp      COA_INV_PERRET_W_S  ara
    ## 6 Amsterdam - Rotterdam - Antwerp COA_RPL_COST_PERRET_D_S  ara
    ##               updated
    ## 1 2015-05-29 08:56:00
    ## 2 2015-05-29 08:56:00
    ## 3 2015-05-29 08:56:00
    ## 4 2015-05-29 09:00:00
    ## 5 2015-05-29 09:00:00
    ## 6 2015-05-29 08:56:00

``` r
mk_list_files(mk_user = mk_user, mk_password = mk_password, only_accessible = TRUE, time_zone = "GMT") %>% head()
```

    ## Source: local data frame [6 x 7]
    ## 
    ##   access    category                  filename               areaname
    ## 1   true Consumption Consumption Hourly Actual Central Eastern Europe
    ## 2   true Consumption Consumption Hourly Actual Central Western Europe
    ## 3   true Consumption Consumption Hourly Actual      Iberian Peninsula
    ## 4   true Consumption Consumption Hourly Actual                  Italy
    ## 5   true Consumption Consumption Hourly Actual              Nord Pool
    ## 6   true Consumption Consumption Hourly Actual      South East Europe
    ## Variables not shown: key (chr), area (chr), updated (time)

Download the files:

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "CON_POW_H_A", mk_area = "cee") %>% head()
```

    ## Data from MKonline.com Updated: ,2015-05-29 09:41, Descriptive name: ,Consumption Hourly Actual, Update frequency,Hourly, on arrival, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## Source: local data frame [6 x 6]
    ## 
    ##               date con_cee_mk01_mwh_h_h_sa con_pl_mk01_mwh_h_h_sa
    ## 1 2015-02-18 00:00                 32058.9                16712.5
    ## 2 2015-02-18 01:00                 31298.0                16362.6
    ## 3 2015-02-18 02:00                 30752.9                16200.1
    ## 4 2015-02-18 03:00                 30542.8                16195.4
    ## 5 2015-02-18 04:00                 30735.4                16309.0
    ## 6 2015-02-18 05:00                 32228.7                17026.1
    ## Variables not shown: con_cz_mk01_mwh_h_h_sa (dbl), con_sk_mk01_mwh_h_h_sa
    ##   (dbl), con_hu_mk01_mwh_h_h_sa (dbl)

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "CON_POW_MK02_H_A", mk_area = "cwe") %>% head()
```

    ## Data from MKonline.com Updated: ,2015-02-26 13:32, Descriptive name: ,Consumption Hourly Actual Mk02, Update frequency,On demand, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## Source: local data frame [6 x 8]
    ## 
    ##               date con_cwe_mk02_mwh_h_h_a con_de_mk02_mwh_h_h_a
    ## 1 2013-01-01 00:00               142280.1               47296.5
    ## 2 2013-01-01 01:00               138141.6               46198.5
    ## 3 2013-01-01 02:00               133557.5               44466.0
    ## 4 2013-01-01 03:00               126819.7               42850.7
    ## 5 2013-01-01 04:00               122074.1               41775.8
    ## 6 2013-01-01 05:00               120319.0               41025.4
    ## Variables not shown: con_fr_mk02_mwh_h_h_a (dbl), con_at_mk02_mwh_h_h_a
    ##   (dbl), con_ch_mk02_mwh_h_h_a (dbl), con_nl_mk02_mwh_h_h_a (dbl),
    ##   con_be_mk02_mwh_h_h_a (dbl)

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "PRO_WND_H_N", mk_area = "np") %>% head()
```

    ## Data from MKonline.com Updated: ,2015-05-29 01:44, Descriptive name: ,Wind Power Production Hourly Normal, Update frequency,When required, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## Source: local data frame [6 x 17]
    ## 
    ##               date pro_npa_wnd_normal_mk02_mwh_h_n
    ## 1 2014-01-01 00:00                          3642.8
    ## 2 2014-01-01 01:00                          3654.0
    ## 3 2014-01-01 02:00                          3639.5
    ## 4 2014-01-01 03:00                          3630.8
    ## 5 2014-01-01 04:00                          3625.6
    ## 6 2014-01-01 05:00                          3617.4
    ## Variables not shown: pro_se_wnd_normal_mk02_mwh_h_n (dbl),
    ##   pro_no_wnd_normal_mk02_mwh_h_n (dbl), pro_dk_wnd_normal_mk02_mwh_h_n
    ##   (dbl), pro_dk1_wnd_normal_mk02_mwh_h_n (dbl),
    ##   pro_dk2_wnd_normal_mk02_mwh_h_n (dbl), pro_fi_wnd_normal_mk02_mwh_h_n
    ##   (dbl), pro_se1_wnd_normal_mk02_mwh_h_n (dbl),
    ##   pro_se2_wnd_normal_mk02_mwh_h_n (dbl), pro_se3_wnd_normal_mk02_mwh_h_n
    ##   (dbl), pro_se4_wnd_normal_mk02_mwh_h_n (dbl),
    ##   pro_no1_wnd_normal_mk02_mwh_h_n (lgl), pro_no2_wnd_normal_mk02_mwh_h_n
    ##   (dbl), pro_no3_wnd_normal_mk02_mwh_h_n (dbl),
    ##   pro_no4_wnd_normal_mk02_mwh_h_n (dbl), pro_no5_wnd_normal_mk02_mwh_h_n
    ##   (dbl)

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "WND_CAP_D_AF", mk_area = "np") %>% head()
```

    ## Data from MKonline.com Updated: ,2015-05-29 01:44, Descriptive name: ,Wind Power Installed Capacity, Update frequency,When required, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## Source: local data frame [6 x 17]
    ## 
    ##         date cap_npa_wnd_total_mk02_mw_d_a cap_se_wnd_total_mk02_mw_d_a
    ## 1 2012-01-02                        7482.0                       2784.1
    ## 2 2012-01-03                        7483.7                       2785.1
    ## 3 2012-01-04                        7485.3                       2786.2
    ## 4 2012-01-05                        7486.9                       2787.3
    ## 5 2012-01-06                        7488.5                       2788.3
    ## 6 2012-01-07                        7490.1                       2789.4
    ## Variables not shown: cap_no_wnd_total_mk02_mw_d_a (dbl),
    ##   cap_dk_wnd_total_mk02_mw_d_a (dbl), cap_dk1_wnd_total_mk02_mw_d_a (dbl),
    ##   cap_dk2_wnd_total_mk02_mw_d_a (dbl), cap_fi_wnd_total_mk02_mw_d_a (dbl),
    ##   cap_se1_wnd_total_mk02_mw_d_a (dbl), cap_se2_wnd_total_mk02_mw_d_a
    ##   (dbl), cap_se3_wnd_total_mk02_mw_d_a (dbl),
    ##   cap_se4_wnd_total_mk02_mw_d_a (dbl), cap_no1_wnd_total_mk02_mw_d_a
    ##   (dbl), cap_no2_wnd_total_mk02_mw_d_a (dbl),
    ##   cap_no3_wnd_total_mk02_mw_d_a (dbl), cap_no4_wnd_total_mk02_mw_d_a
    ##   (dbl), cap_no5_wnd_total_mk02_mw_d_a (dbl)

See the info attributes:

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "CON_POW_H_A", mk_area = "cee") %>% attr(x = ., which = "info")
```

    ## Data from MKonline.com Updated: ,2015-05-29 09:41, Descriptive name: ,Consumption Hourly Actual, Update frequency,Hourly, on arrival, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## NULL

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "CON_POW_MK02_H_A", mk_area = "cwe") %>% attr(x = ., which = "info")
```

    ## Data from MKonline.com Updated: ,2015-02-26 13:32, Descriptive name: ,Consumption Hourly Actual Mk02, Update frequency,On demand, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## NULL

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "PRO_WND_H_N", mk_area = "np") %>% attr(x = ., which = "info")
```

    ## Data from MKonline.com Updated: ,2015-05-29 01:44, Descriptive name: ,Wind Power Production Hourly Normal, Update frequency,When required, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## NULL

``` r
mk_download_file(mk_user = mk_user, mk_password = mk_password, mk_file = "WND_CAP_D_AF", mk_area = "np") %>% attr(x = ., which = "info")
```

    ## Data from MKonline.com Updated: ,2015-05-29 01:44, Descriptive name: ,Wind Power Installed Capacity, Update frequency,When required, Data Frequency,MWh Hourly,Timezone:,Europe/Oslo,

    ## NULL
