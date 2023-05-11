#!/bin/bash
#https://github.com/cert-manager/cert-manager
kubectl create ns cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v<<version>>/cert-manager.crds.yaml
