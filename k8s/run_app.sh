#!/bin/bash

####Preparing


echo "Stage 2 Deploy APP"
sleep 2

echo '2.1: Load Registry credential'
kubectl create -f docker_secret.yaml 

sleep 1

echo '2.2: load PSQL configmap'
kubectl create -f postgres_configmap.yaml 

sleep 1

echo '2.3: Create storage for PSQL'
kubectl create -f postgres_storage.yaml 

sleep 1

echo '2.4: Deploy PSQL'
kubectl create -f postgres_dep.yaml


sleep 1

echo '2.5: Create network service for PSQL'

kubectl create -f postgres_service.yaml 


sleep 1 


echo '2.6: load APP configmap'
kubectl create -f app_configmap.yaml 

sleep 1 



echo '2.7: Create secret for APP'
kubectl create -f app_secret.yaml

sleep 1 

echo '2.8: Deploy APP'

kubectl create -f app_dep.yaml

echo '2.9: Create network service for PSQL'
mc
kubectl create -f app_service.yaml 

echo '2.10: Create Ingress conroller for APP'
kubectl apply -f app_ingress.yaml


sleep 6

kubectl get pods -n deafault

kubectl get pods  -n kube-system | grep fluentd



