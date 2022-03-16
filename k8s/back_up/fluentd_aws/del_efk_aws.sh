#!/bin/bash

####Preparing
echo "Destroy ELK"

echo '1.3: delete Service for Kibana'
kubectl delete -f elk/kibana_svc.yaml

echo '1.4: Deploy Kibana'
kubectl delete -f elk/kibana_dep.yaml

echo '1.1: delete Service for Elastic'

kubectl delete -f elk/els_service.yaml

echo '1.2: Deploy Elastic Statefulset'
kubectl delete -f elk/els_statefulset.yaml




echo '1.9: delete cwagent_daemonset'
kubectl delete -f elk/fluentd_aws/cwagent_daemonset.yaml




echo '1.6: delete cluster_role_binding cloudwatch'
kubectl delete -f elk/fluentd_aws/cluster_role_binding.yaml

echo '1.7: delete cluster_role_rbac'

kubectl delete -f elk/fluentd_aws/cluster_role_rbac.yaml

echo '1.8: Load cwagent_configmap'
kubectl delete -f elk/fluentd_aws/cwagent_configmap.yaml

echo '1.5: Cr cloudwatch namespace'
kubectl delete  -f elk/fluentd_aws/cloudwatch_namespace.yaml




kubectl delete -f elk/fluentd_aws/cwagent_sa_rb.yaml

elk/fluentd_aws/aws_reg_clus_name_configmap.yaml | sed "s/{{cluster_name}}/mycluster-v2/;s/{{region_name}}/eu-central-1/" | kubectl apply -f -
#kubectl delete -f elk/fluentd_aws/aws_reg_clus_name_configmap.yaml

kubectl delete -f elk/fluentd_aws/fluentd_daemonset.yaml

kubectl delete -f elk/fluentd_aws/fluentd_sa.yaml

kubectl delete -f elk/fluentd_aws/fluentd_rbac.yaml

kubectl delete -f elk/fluentd_aws/fluentd_rbac_binding.yaml

kubectl delete -f elk/fluentd_aws/fluentd_config.yaml




