#!/bin/bash

####Deploy  Promethetus /Grafana /TG bot

echo "Stage 3: Deploy Prometheus"
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

echo '5: Deploy Nodeexp'
kubectl create -f prom/nodeexp_daemonset.yaml

echo '6: Create Nodeexp Service '
kubectl create -f prom/nodeexp_svc.yaml

echo '7: Deploy Prometheus'
kubectl create -f prom/prometheus_dep.yaml

echo '8: Create Prometheus Service'
kubectl create -f prom/prom_svc.yaml
sleep 1


echo '9: Load Alertmnager configmap'
kubectl create -f prom/alertm_configmap.yaml
sleep 1

echo '10: Load Alertmnager template'
kubectl create -f prom/alertm_template.yaml
sleep 1

echo '11: Deploy Alertmnager'
kubectl create -f prom/alertm_dep.yaml
sleep 1

echo '12: Create Alertmnager Service'
kubectl create -f prom/alertm_srv.yaml
sleep 1

echo '13: Create volume for Telegram bot '
kubectl create -f prom/bot_vol.yaml
sleep 1

echo '14: Deploy TG bot container'
kubectl create -f prom/prom_bot_depl.yaml
sleep 1

echo '15: Load Grafana configs'
kubectl create -f prom/grafana_configmap.yaml
sleep 1

echo '16: Deploy Grafana'
kubectl create -f prom/grafana_dep.yaml
sleep 1

echo '17: Create Grafana Service'
kubectl create -f prom/grafana_svc.yaml
sleep 1

echo "Waiting"
sleep 4

kubectl get svc -n monitoring


kubectl get pods -n monitoring




