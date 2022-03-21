#!/bin/bash

####Destroy

echo "Destroy Ingress"

kubectl delete -f nginx_ingress/prom_ingress_base_auth.yaml

kubectl delete -f nginx_ingress/app_ingress_base_auth.yaml
sleep 5

kubectl delete -f nginx_ingress/nginx_ing_v2.yaml

kubectl delete -f nginx_ingress/nginx_secret.yaml

kubectl get pods 

kubectl get svc


