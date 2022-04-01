#!/bin/bash

####Destroy Ingress Rules

echo "Destroy Ingress Rules"

kubectl delete -f nginx_ingress/prom_ingress_base_auth.yaml
sleep 1
kubectl delete -f nginx_ingress/app_ingress_base_auth.yaml
sleep 1

kubectl delete -f nginx_ingress/grafana_ingress.yaml
sleep 1

kubectl delete -f nginx_ingress/nginx_base_auth_secret.yaml
sleep 1

kubectl delete -f nginx_ing_contr/nginx_ing_contr.yaml
sleep 1



