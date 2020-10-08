# Demo - Pod Security Policy on EKS

```bash
brew install yq

yq merge -a overwrite -x ../baseline/cluster.yml ./cluster.tpl.yml > cluster.yml

eksctl create cluster -f ./cluster.yml

kubectl delete psp/eks.privileged

kubectl delete -f ./psp-default.yml
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

kubectl delete -f ./example-unprivileged.yml
kubectl delete -f ./example-privileged.yml

# try to deploy containers as unprivileged, only unprivileged container should pass
kubectl-user apply -f ./example-unprivileged.yml
kubectl-user apply -f ./example-privileged.yml

kubectl-user delete -f ./example-unprivileged.yml
kubectl-user delete -f ./example-privileged.yml
```
