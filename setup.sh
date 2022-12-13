#!/bin/bash

# Install clusterctl
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.3.0/clusterctl-linux-amd64 -o clusterctl
sudo install -o root -g root -m 0755 clusterctl /usr/local/bin/clusterctl
clusterctl version

#
# Install management cluster (kind)
#
cat > ./mgmt/kind-mgmt-cluster-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
    - hostPath: /var/run/docker.sock
      containerPath: /var/run/docker.sock
EOF

kind create cluster \
    --config ./mgmt/kind-mgmt-cluster-config.yaml \
    --name kind-mgmt-cluster

kubectl cluster-info --context kind-kind

# Initialize the management cluster. https://cluster-api.sigs.k8s.io/user/quick-start.html
export CLUSTER_TOPOLOGY=true
clusterctl init --infrastructure docker

kubectl get po -A
kubectl get ns
kubectl get cluster -w

#  Apply workload clusters
kubectl apply -f ./mgmt/cluster-c1.yaml
kubectl apply -f ./mgmt/cluster-c2.yaml

# glance view of cluster
clusterctl describe cluster cluster-c1

# Verify that the control plane is up and running
kubectl get kubeadmcontrolplane

# Access the workload cluster
kind get kubeconfig --name cluster-c1 > cluster-c1.kubeconfig
kind get kubeconfig --name cluster-c1 > cluster-c2.kubeconfig

# Deply CNI solution

# cluster-c1
kubectl --kubeconfig=./cluster-c1.kubeconfig \
  apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calico.yaml

kubectl --kubeconfig=./cluster-c1.kubeconfig get nodes -w

# cluster-c2
kubectl --kubeconfig=./cluster-c2.kubeconfig \
  apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calico.yaml

kubectl --kubeconfig=./cluster-c2.kubeconfig get nodes -w


