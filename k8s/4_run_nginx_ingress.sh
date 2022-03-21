#!/bin/bash

####Preparing

echo '1: Load App ingress '
kubectl create -f nginx_ingress/app_ingress_base_auth.yaml
sleep 2

echo '1: Load Prometheus ingress'
kubectl create -f nginx_ingress/prom_ingress_base_auth.yaml
sleep 2

