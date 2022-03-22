#!/bin/bash

####One step destroing


source  5_del_nginx_ingress.sh
sleep 1

source 6_del_prom_alert.sh
sleep 1

source 7_del_efk.sh
sleep 1

source 8_del_app.sh

echo "Waiting"
sleep 5

kubectl get pods --all-namespaces

kubectl get svc --all-namespaces

kubectl get ing --all-namespaces











