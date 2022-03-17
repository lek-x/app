#!/bin/bash

####Preparing
echo "Destroy ELK"

echo '1: Destroy Fluentd Daemonset'
kubectl delete -f elk/fluentd_daemonset.yaml
sleep 1

echo '2: Delete Cluster Role Binding for Fluentd'
kubectl delete -f elk/fluentd_clrb.yaml
sleep 1

echo '3: Delete Service Account for Fluentd'
kubectl delete -f elk/fluentd_serv_acc.yml
sleep 1

echo '4: Delete Role for Fluentd in kube-system namespace'
kubectl delete -f elk/fluentd_role.yaml
sleep 1

echo '5: Delete Configmap for Fluentd'
kubectl delete  -f elk/fluentd_configmap.yaml
sleep 1

echo '6: Delete Service for Kibana'
kubectl delete -f elk/kibana_svc.yaml
sleep 1

echo '7: Destroy Kibana'
kubectl delete -f elk/kibana_dep.yaml
sleep 1

echo '8: Destroy Elastic Statefulset'
kubectl delete -f elk/els_statefulset.yaml
sleep 1

echo '9: Delete Service for Elastic'
kubectl delete -f elk/els_service.yaml
sleep 1

kubectl get pods

kubectl get svc















sleep 3


