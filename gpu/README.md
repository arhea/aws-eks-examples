# GPU Demo

This demo is designed to show how to provision a cluster with GPU instances. This configuration will spin up a cluster in `us-east-1` with two node groups, one running general purpose compute and another running on GPUs.

```bash
# merge the baseline cluster configuration with this cluster
yq merge -a overwrite -x ../baseline/cluster.yml ./cluster.tpl.yml > cluster.yml

# deploy the environment
eksctl create cluster -f ./cluster.yml
```

_This takes about 25-30 minutes to complete._

## Deploy NVIDIA Drivers

```bash
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.7.0/nvidia-device-plugin.yml
```

## Deploy Cluster Autoscaler

```bash
kubectl create -f ./cluster-autoscaler.yml
```

## Deploy Sample GPU Application

```bash
kubectl apply -f ./example.yml
```

## Deploy Amazon EBS CSI Driver

```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
```

## Deploy Amazon EFS CSI Driver

```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.0"
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
