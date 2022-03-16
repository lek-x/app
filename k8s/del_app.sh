#!/bin/bash

####Destroy

echo "Destroy APP"

echo '1: Delete network service for App'
kubectl delete -f app/app_service.yaml 
sleep 1

echo '2: Destroy APP'
kubectl delete -f app/app_dep.yaml
sleep 1

echo '3: Delete secret for APP'
kubectl delete -f app/app_secret.yaml
sleep 1

#echo '4: Delete APP configmap'
#kubectl delete -f app_configmap.yaml 
#sleep 1

echo '5: Delete network service for PSQL'
kubectl delete -f app/postgres_service.yaml 
sleep 1

echo '6: Destroy PSQL'
kubectl delete -f app/postgres_dep.yaml
sleep 1

echo '7: Delete storage for PSQL'
kubectl delete -f app/postgres_storage.yaml 
sleep 1


echo '8: Delete Registry credential'
kubectl delete -f app/docker_secret.yaml 
sleep 1

echo '9: Delete PSQL configmap'
kubectl delete -f app/postgres_configmap.yaml 
sleep 1


kubectl get pods 

kubectl get svc


