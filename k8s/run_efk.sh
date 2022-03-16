#!/bin/bash

####ELK
echo "Stage: Deploy ELK"


echo '1.1: Deploy Elastic Statefulset'
kubectl create -f elk/els_statefulset.yaml

echo '1.2: Create Service for Elastic'
kubectl create -f elk/els_service.yaml

echo '1.3: Deploy Kibana'
kubectl create -f elk/kibana_dep.yaml

echo '1.4: Create Service for Kibana'
kubectl create -f elk/kibana_svc.yaml


echo '1.5: Load Configmap for Fluentd'
kubectl create  -f elk/fluentd_configmap.yaml

echo '1.6: Create Role for Fluentd in kube-system namespace'
kubectl create -f elk/fluentd_role.yaml

echo '1.7: Load Service Account for Fluentd'
kubectl create -f elk/fluentd_serv_acc.yml

echo '1.8: Load Cluster Role Binding for Fluentd'
kubectl create -f elk/fluentd_clrb.yaml

echo '1.9: Deploy Fluentd Daemonset'
kubectl create -f elk/fluentd_daemonset.yaml


kubectl get svc

kubectl get pods

kubectl get pods -n kube-system | grep fluentd



