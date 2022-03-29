#!/bin/bash

echo "Stage: Destroy Prometheus , Alertmanager, Grafana, TG Bot"

##############Prometheus

echo '1: Delete Service'
kubectl delete -f prom/prom_svc.yaml
sleep 1

echo '2: Destroy Prometheus'
kubectl delete -f prom/prometheus_dep.yaml
sleep 1

echo '3: Delete Prometheus Role binding'
kubectl delete -f prom/prom_clusterrole_bind.yaml
sleep 1

echo '4: Delete Prometheus Cluster Role'
kubectl delete -f prom/prom_clusterrole.yaml 
sleep 1


echo '5: Delete Prometheus configmap'
kubectl delete -f prom/prometheus_configmap.yaml
sleep 1

##############Node exporter
echo '1: Delete Node exporter'
kubectl delete -f prom/nodeexp_daemonset.yaml
sleep 1
echo '1: Delete Node exporte Service '
kubectl delete -f prom/nodeexp_svc.yaml
sleep 1

##############TG BOT
echo '6: Destroy TG bot container'
kubectl delete -f prom/prom_bot_depl.yaml
sleep 1
echo '7: Delete volume for Telegram bot '
kubectl delete -f prom/bot_vol.yaml
sleep 1

##############Alertmanager
echo '8: Delete Alertmnager Service'
kubectl delete -f prom/alertm_srv.yaml
sleep 1

echo '9: Destroy Alertmnager'
kubectl delete -f prom/alertm_dep.yaml
sleep 1
echo '10: Destroy Alertmnager configmap'
kubectl delete -f prom/alertm_configmap.yaml
sleep 1

echo '11: Destroy Alertmnager template'
kubectl delete -f prom/alertm_template.yaml
sleep 1


##############kube state metrics
echo '12: Destroy kube_state_metrics'
kubectl delete -f prom/kube_state_metrics.yaml
sleep 1


##############Grafana
echo '13: Destroy Grafana deployment'
kubectl delete -f prom/grafana_dep.yaml
sleep 1

echo '14: Destroy Grafana configmap'
kubectl delete -f prom/grafana_configmap.yaml
sleep 1

echo '15: Destroy Grafana Service'
kubectl delete -f prom/grafana_svc.yaml
sleep 1

echo '16: Destroy namespace'
kubectl delete -f prom/prom_namespace.yaml
sleep 1






