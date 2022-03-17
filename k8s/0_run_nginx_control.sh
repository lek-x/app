#!/bin/bash

####Destroy

echo "Deploy  NGINX Ingress controller"
kubectl create -f nginx_ingress/nginx_ing_v2.yaml


