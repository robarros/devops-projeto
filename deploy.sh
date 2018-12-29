#!/bin/bash
sed -i "s/IMAGE1/${IMAGE_NAME}:${IMAGE_VERSION}/" Deployment.yaml
cat Deployment.yaml
# kubectl apply -f Deployment.yaml


