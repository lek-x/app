#!/bin/bash

####Deploy NGINX ingress controller

echo "Stage 0:"

echo "1: Deploy  NGINX Ingress controller"
kubectl create -f nginx_ing_contr/nginx_ing_contr.yaml

echo "2: Deploy  Metrics-server"
kubectl create -f hpa/components.yaml


echo "2: Deploy  Metrics-server"
kubectl create -f hpa/auto_scaler.yaml


