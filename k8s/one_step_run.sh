#!/bin/bash

####Preparing


source  0_run_nginx_control.sh
sleep 1
source 1_run_app.sh
sleep 1
source 2_run_efk.sh
sleep 1
source 3_run_prom_alert.sh
sleep 1
source 4_run_nginx_ingress.sh







