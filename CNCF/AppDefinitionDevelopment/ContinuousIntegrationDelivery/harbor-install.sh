#!/bin/bash
#https://github.com/goharbor/harbor
helm repo add harbor https://helm.goharbor.io
helm pull harbor/harbor --untar
