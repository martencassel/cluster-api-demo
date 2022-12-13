#!/bin/bash

# Grant argocd to manage Cluster API objects
cat > ./argocd/cluster-api-argocd-rbac.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin-argocd-contoller
subjects:
  - kind: ServiceAccount
    name: argocd-application-controller
    namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
EOF

kubectl apply -f ./argocd/cluster-api-argocd-rbac.yaml

# Create argocd applications per cluster

#
# cluster c1
#
cat > ./argocd/c1-cluster-create.yaml <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: c1-cluster-create
spec:
  destination:
    name: ''
    namespace: ''
    server: 'https://kubernetes.default.svc'
  source:
    path: mgmt
    repoURL: 'https://github.com/piomin/sample-kubernetes-cluster-api-argocd.git'
    targetRevision: HEAD
  project: default
EOF

#
# cluster c2
#
cat > ./argocd/c2-custer-create.yaml <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: c2-cluster-create
spec:
  destination:
    name: ''
    namespace: ''
    server: 'https://kubernetes.default.svc'
  source:
    path: mgmt
    repoURL: 'https://github.com/piomin/sample-kubernetes-cluster-api-argocd.git'
    targetRevision: HEAD
  project: default
EOF


# Manage workloads cluster with argocd

