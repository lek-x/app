#!/bin/bash

####Preparing

echo "Stage: Deploy Prometheus"
sleep 2
echo '1: Deploy kube_state_metrics'
kubectl create -f prom/kube_state_metrics.yaml

echo '1: Create namespace'
kubectl create -f prom/prom_namespace.yaml

echo '2: Create cr Role'
kubectl create -f prom/prom_clusterrole.yaml 
sleep 1

echo '3: Create bind Role'
kubectl create -f prom/prom_clusterrole_bind.yaml

echo '4: load Prometheus configmap'
kubectl create -f prom/prometheus_configmap.yaml
sleep 1

echo '5: Deploy Prometheus'
kubectl create -f prom/prometheus_dep.yaml

echo '6: Create Service'
kubectl create -f prom/prom_svc.yaml
sleep 1


echo '7: Load Alertmnager configmap'
kubectl create -f prom/alertm_configmap.yaml
sleep 1

echo '8: Load Alertmnager template'
kubectl create -f prom/alertm_template.yaml

echo '9: Deploy Alertmnager'
kubectl create -f prom/alertm_dep.yaml

echo '10: Create Alertmnager Service'
kubectl create -f prom/alertm_srv.yaml

echo '12: Create volume for Telegram bot '
kubectl create -f prom/bot_vol.yaml

echo '13: Deploy TG bot container'
kubectl create -f prom/prom_bot_depl.yaml


kubectl get svc -n monitoring


kubectl get pods -n monitoring




