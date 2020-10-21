
build:
	# merge the configurations
	yq merge -a overwrite -x ../baseline/cluster.yml ./cluster.tpl.yml > cluster.yml

create: build
	# create the cluster
	eksctl create cluster -f ./cluster.yml

	# deploy the nvidia drivers
	kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.7.0/nvidia-device-plugin.yml

	# deploy cluster autoscaler
	kubectl create -f ./cluster-autoscaler.yml

	# deploy the ebs csi driver
	kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

	# deploy the efs csi driver
	kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.0"

	# deploy the dashoard
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
	kubectl apply -f ./dashboard-admin.yml

update: build
	# update the cluster
	eksctl update cluster -f ./cluster.yml

destroy:
	# delete the cluster
	eksctl delete cluster -f ./cluster.yml
