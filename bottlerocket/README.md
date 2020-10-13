# Amazon EKS Example - Bottlerocket OS

```bash

# merge the baseline cluster configuration with this cluster
yq merge -a overwrite -x ../baseline/cluster.yml ./cluster.tpl.yml > cluster.yml

# create the cluster
eksctl create cluster -f ./cluster.yml

# deploy the update controller
kubectl apply -f https://raw.githubusercontent.com/bottlerocket-os/bottlerocket-update-operator/develop/update-operator.yaml

```
