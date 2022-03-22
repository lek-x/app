#!/bin/bash

####Deploy NGINX ingress controller

echo "Stage 0:"

echo "1: Deploy  NGINX Ingress controller"
kubectl create -f nginx_ing_contr/nginx_ing_contr.yaml


