#!/bin/bash

####Destroy ELK 
echo "Destroy ELK"

echo '1: Destroy Fluentd Daemonset'
kubectl delete -f elk/fluentd_daemonset.yaml
sleep 1

echo '2: Delete Fluentd Cluster Role Binding'
kubectl delete -f elk/fluentd_clrb.yaml
sleep 1

echo '3: Delete Fluentd Service Account'
kubectl delete -f elk/fluentd_serv_acc.yml
sleep 1

echo '4: Delete Role for Fluentd in kube-system namespace'
kubectl delete -f elk/fluentd_role.yaml
sleep 1

echo '5: Delete Fluentd Configmap'
kubectl delete  -f elk/fluentd_configmap.yaml
sleep 1

echo '6: Delete Kibana Service'
kubectl delete -f elk/kibana_svc.yaml
sleep 1

echo '7: Destroy Kibana deployment'
kubectl delete -f elk/kibana_dep.yaml
sleep 1

echo '8: Destroy Elasticsearch Statefulset'
kubectl delete -f elk/els_statefulset.yaml
sleep 1

echo '9: Delete Elasticsearch Service'
kubectl delete -f elk/els_service.yaml
sleep 1















sleep 3


