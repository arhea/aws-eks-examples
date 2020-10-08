# Amazon EKS Example - Pod Security Policy on EKS

```bash

# merge the baseline cluster configuration with this cluster
yq merge -a overwrite -x ../baseline/cluster.yml ./cluster.tpl.yml > cluster.yml

# create the cluster
eksctl create cluster -f ./cluster.yml

# delete the default psp objects in eks
kubectl delete -f ./psp-default.yml

# apply the privileged and restricted psps defined in this folder
kubectl apply -f ./psp-privileged.yml
kubectl apply -f ./psp-restricted.yml

# create a fake user
kubectl create serviceaccount -n default fake-user
kubectl create rolebinding -n default fake-editor --clusterrole=edit --serviceaccount=default:fake-user

# alias unprivileged user
alias kubectl-user='kubectl --as=system:serviceaccount:default:fake-user -n default'

# check administrator privileges
kubectl auth can-i use podsecuritypolicy/eks.privileged
kubectl auth can-i use podsecuritypolicy/eks.restricted

# check unprivileged privileges
kubectl-user auth can-i use podsecuritypolicy/eks.privileged
kubectl-user auth can-i use podsecuritypolicy/eks.restricted

# try to deploy containers as admin, both should pass
kubectl apply -f ./example-unprivileged.yml
kubectl apply -f ./example-privileged.yml

# cleanup examples
kubectl delete -f ./example-unprivileged.yml
kubectl delete -f ./example-privileged.yml

# try to deploy containers as unprivileged, only unprivileged container should pass
kubectl-user apply -f ./example-unprivileged.yml
kubectl-user apply -f ./example-privileged.yml

# cleanup examples
kubectl-user delete -f ./example-unprivileged.yml
kubectl-user delete -f ./example-privileged.yml
```
