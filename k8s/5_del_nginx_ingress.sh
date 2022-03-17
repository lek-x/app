#!/bin/bash

####Destroy

echo "Destroy Ingress"

kubectl delete -f nginx_ingress/prom_ingress.yaml

kubectl delete -f nginx_ingress/app_ingress.yaml
sleep 5

kubectl delete -f nginx_ingress/nginx_ing_v2.yaml

kubectl get pods 

kubectl get svc


