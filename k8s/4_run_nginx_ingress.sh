#!/bin/bash

####Preparing

echo '1: Load App ingress '
kubectl create -f nginx_ingress/app_ingress.yaml
sleep 2

echo '1: Load Prometheus ingress'
kubectl create -f nginx_ingress/prom_ingress.yaml

sleep 2

