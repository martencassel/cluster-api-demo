#!/bin/bash

kubectl create ns argocd
kubectl apply -n=argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl get po -n=argocd -w

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
m2qYaKIHzGZj8QiZ
kubectl port-forward svc/argocd-server 8080:80