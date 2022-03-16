#!/bin/bash

####Preparing

echo "Stage: Deploy APP"
sleep 3

echo '1: Load Registry credential'
kubectl create -f app/docker_secret.yaml 
sleep 1

echo '2: load PSQL configmap'
kubectl create -f app/postgres_configmap.yaml 
sleep 1

echo '3: Create storage for PSQL'
kubectl create -f app/postgres_storage.yaml 
sleep 1

echo '4: Deploy PSQL'
kubectl create -f app/postgres_dep.yaml
sleep 1


echo '5: Create network service for PSQL'
kubectl create -f app/postgres_service.yaml 
sleep 1 


echo '6: load APP configmap[skip]'
#kubectl create -f app/app_configmap.yaml 
#sleep 1 


echo '7: Create secret for APP'
kubectl create -f app/app_secret.yaml
sleep 1 

echo '8: Deploy APP'
kubectl create -f app/app_dep.yaml
sleep 1 


echo '9: Create network service for PSQL'
kubectl create -f app/app_service.yaml 
sleep 1 


kubectl get svc 

kubectl get pods -n deafault




