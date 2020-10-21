
build:
	# merge the configurations
	yq merge -a overwrite -x ../baseline/cluster.yml ./cluster.tpl.yml > cluster.yml

create: build
	# create the cluster
	eksctl create cluster -f ./cluster.yml

	# deploy the update operator
	kubectl apply -f https://raw.githubusercontent.com/bottlerocket-os/bottlerocket-update-operator/develop/update-operator.yaml

	# deploy the dashboard
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

update: build
	# update the cluster
	eksctl update cluster -f ./cluster.yml

destroy:
	# delete the cluster
	eksctl delete cluster -f ./cluster.yml
