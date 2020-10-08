# Fargate Demo

This demo is designed to show how to provision a cluster using Fargate.

## Usage

Create the cluster based on the configuration in the [cluster.yml](./cluster.yml). This configuration will spin up a cluster in `us-east-2` where all of the pods in the `kube-system` and `default` namespace are scheduled to Fargate. The rest of the pods will be scheduled to the Node Group.

```bash
eksctl create cluster -f ./cluster.yml --profile=personal
```

_This takes about 25-30 minutes to complete._

Deploy the Kubernetes Dashboard:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
```

To access the dashboard run:

```bash
kubectl proxy
```

Then visit: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

```fish
set -gx AWS_PROFILE personal; aws-iam-authenticator token -i fargate-demo-cluster | jq -r '.status.token'
```

Deploy the ALB Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml
kubectl edit deployment.apps/alb-ingress-controller -n kube-system
```

Deploy 2048

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-service.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-ingress.yaml
```
