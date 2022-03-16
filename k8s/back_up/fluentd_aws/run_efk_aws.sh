#!/bin/bash

####Preparing
echo "Stage : Deploy ELK"



echo '1: Cr cloudwatch namespace'
kubectl create  -f elk/fluentd_aws/cloudwatch_namespace.yaml
sleep 1

echo '2: Create cluster_role_binding cloudwatch'
kubectl create -f elk/fluentd_aws/cluster_role_binding.yaml
sleep 1

echo '3: create cluster_role_rbac'
kubectl create -f elk/fluentd_aws/cluster_role_rbac.yaml
sleep 1

echo '4: Load cwagent_configmap'
kubectl create -f elk/fluentd_aws/cwagent_configmap.yaml
sleep 1

echo '5: create cwagent_daemonset'
kubectl create -f elk/fluentd_aws/cwagent_daemonset.yaml
sleep 1


echo '6: cwagent_sa_rb'
kubectl create -f elk/fluentd_aws/cwagent_sa_rb.yaml
sleep 1

echo '7: aws_reg_clus_name_configmap'
elk/fluentd_aws/aws_reg_clus_name_configmap.yaml | sed "s/{{cluster_name}}/mycluster-v2/;s/{{region_name}}/eu-central-1/" | kubectl apply -f -
#kubectl create -f elk/fluentd_aws/aws_reg_clus_name_configmap2.yaml
sleep 1


echo '8: cwagent_sa_rb'
kubectl create -f elk/fluentd_aws/fluentd_sa.yaml
sleep 1

echo '9: cwagent_sa_rb'
kubectl create -f elk/fluentd_aws/fluentd_rbac.yaml
sleep 1

echo '10: cwagent_sa_rb'
kubectl create -f elk/fluentd_aws/fluentd_rbac_binding.yaml
sleep 1

echo '11: cwagent_sa_rb'
kubectl create -f elk/fluentd_aws/fluentd_config.yaml
sleep 1

echo '12: cwagent_sa_rb'
kubectl create -f elk/fluentd_aws/fluentd_daemonset.yaml
sleep 1


echo '13: Create Service for Elastic'
kubectl create -f elk/els_service.yaml
sleep 1

echo '14: Deploy Elastic Statefulset'
kubectl create -f elk/els_statefulset.yaml
sleep 1

echo '15: Deploy Kibana'
kubectl create -f elk/kibana_dep.yaml
sleep 1

echo '16: Create Service for Kibana'
kubectl create -f elk/kibana_svc.yaml
sleep 1





