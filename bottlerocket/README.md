# Amazon EKS Example - Bottlerocket OS

```bash

# merge the baseline cluster configuration with this cluster
yq merge -a overwrite -x ../baseline/cluster.yml ./cluster.tpl.yml > cluster.yml

# create the cluster
eksctl create cluster -f ./cluster.yml

# deploy the update controller
kubectl apply -f https://raw.githubusercontent.com/bottlerocket-os/bottlerocket-update-operator/develop/update-operator.yaml

# deploy kubernetes dashboard
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
kubectl apply -f ./dashboard-admin.yml
```

### Kubernetes Dashboard

```bash
# deploy kubernetes dashboard
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
kubectl apply -f ./dashboard-admin.yml

# enable the proxy
kubectl proxy
# open the browser to http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# fetch the token
kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep dashboard-admin | awk '{print $1}') -o jsonpath='{.data.token}'
```

### Fluentbit Logging

```bash

eksctl create iamserviceaccount \
    --cluster bottlerocket \
    --name fluent-bit \
    --namespace logging \
    --attach-policy-arn "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" \
    --approve

kubectl apply -f ./fluentbit.yml

```
