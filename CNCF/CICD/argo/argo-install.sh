#!/bin/bash
#https://argoproj.github.io/argo-workflows/quick-start/

kubectl create namespace argo
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v<<ARGO_WORKFLOWS_VERSION>>
