#!/bin/bash

# https://piotrminkowski.com/2021/12/03/create-kubernetes-clusters-with-cluster-api-and-argocd/

# 1. Generate cluster manifests

# 2. Template the cluster manifests

# 3. Example templating (values.yaml with helm)

cluster:
  name: c1
  masterNodes: 3
  workerNodes: 3
  version: v1.21.1