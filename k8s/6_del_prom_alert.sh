#!/bin/bash



echo "Stage: Destroy Prometheus and Alertmanager"
sleep 2

echo '1: Delete Service'
kubectl delete -f prom/prom_svc.yaml
sleep 1

echo '2: Destroy Prometheus'
kubectl delete -f prom/prometheus_dep.yaml
sleep 1

echo '3: Delete bind Role'
kubectl delete -f prom/prom_clusterrole_bind.yaml
sleep 1
echo '4: Delete cr Role'
kubectl delete -f prom/prom_clusterrole.yaml 
sleep 1


echo '5: Delete Prometheus configmap'
kubectl delete -f prom/prometheus_configmap.yaml
sleep 1


##############Alertmanager
echo '6: Destroy TG bot container'
kubectl delete -f prom/prom_bot_depl.yaml
sleep 1
echo '7: Delete volume for Telegram bot '
kubectl delete -f prom/bot_vol.yaml
sleep 1

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

echo '12: Destroy namespace'
kubectl delete -f prom/prom_namespace.yaml





kubectl get svc -n monitoring


kubectl get pods -n monitoring






