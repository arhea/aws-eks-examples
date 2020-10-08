# Firelens Demo

This demo is designed to show how to provision a cluster that uses Firelens for logging.

## Deploy the Cluster

In this demo, we provision the cluster using [eksctl](https://eksctl.io/), the official CLI tool of EKS. This will provision a cluster with a few service accounts preconfigured. Inspect the `cluster.yml` file for details.

```bash
eksctl create cluster -f ./cluster.yml
```

## Deploy the AWS ALB Ingress Controller

The ALB Ingress Controller will enable your resources to provision Application Load Balancers via Ingress resources. This Chart will leverage the `alb-ingress-controller` service account we created via the `cluster.yml` file. This service account has the IAM permissions required operate.

```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm upgrade -i aws-alb incubator/aws-alb-ingress-controller \
  --namespace kube-system \
  --set clusterName=firelens-demo-cluster \
  --set awsRegion=us-east-2 \
  --set autoDiscoverAwsVpcID=true \
  --set image.tag=v1.1.4 \
  --set rbac.create=true \
  --set rbac.serviceAccountName=alb-ingress-controller
```

## Deploy the Cluster AutoScaler

This cluster autoscaler will enable the ASG associated with the cluster to scale up and down based on resource requirements. This Chart will also leverage the `cluster-autoscaler` service account created via the `cluster.yml`.

```bash
helm upgrade -i cluster-autoscaler stable/cluster-autoscaler \
  --namespace kube-system \
  --set awsRegion=us-east-2 \
  --set autoDiscovery.enabled=true \
  --set autoDiscovery.clusterName=firelens-demo-cluster \
  --set rbac.create=true \
  --set serviceAccount.name=cluster-autoscaler
```

## Deploy the Firelens DaemonSet

To leverage Firelens with EKS we deploy a DaemonSet. This DaemonSet will leverage the `fluentbit` service account we created in the `cluster.yml` to have access to write logs to Cloudwatch and Firehose. This is configured to create and write logs to the `fluentbit-cloudwatch` log group within Cloudwatch Logs.

```bash
kubectl apply -f ./firelens.yml
```
