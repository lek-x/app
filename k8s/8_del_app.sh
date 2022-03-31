#!/bin/bash

####Destroy APP and DB

echo "Destroy APP"

echo '1: Delete  App service'
kubectl delete -f app/app_service.yaml 
sleep 1

echo '2: Destroy APP'
kubectl delete -f app/app_dep.yaml
sleep 1

echo '3: Delete APP secret'
kubectl delete -f app/app_secret.yaml
sleep 1


echo '4: Delete APP configmap'
kubectl delete -f app_configmap.yaml 
sleep 1

echo '5: Delete PSQL Service'
kubectl delete -f app/postgres_service.yaml 
sleep 1

echo '6: Destroy PSQL deployment'
kubectl delete -f app/postgres_dep.yaml
sleep 1

echo '7: Delete PSQL storage'
kubectl delete -f app/postgres_storage.yaml 
sleep 1


echo '8: Delete Dcoker Registry credentials'
kubectl delete -f app/docker_secret.yaml 
sleep 1

echo '9: Delete PSQL configmap'
kubectl delete -f app/postgres_configmap.yaml 
sleep 1

echo '10: Delete PSQL secret'
kubectl delete -f app/postgres_secret.yaml 



