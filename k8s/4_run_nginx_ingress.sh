#!/bin/bash

####Preparing

echo "Stage 4: Deploy Ingress Rules
"
echo '1: Load Nginx secrets '
kubectl create -f nginx_ingress/nginx_base_auth_secret.yaml

echo '2: Load App ingress '
kubectl create -f nginx_ingress/app_ingress_base_auth.yaml
sleep 2

echo '3: Load Prometheus ingress'
kubectl create -f nginx_ingress/prom_ingress_base_auth.yaml
sleep 2

echo '4: Load Grafana ingress'
kubectl create -f nginx_ingress/grafana_ingress.yaml


echo "Waiting"
sleep 4



kubectl get ing -n monitoring 
kubectl get ing -n default

