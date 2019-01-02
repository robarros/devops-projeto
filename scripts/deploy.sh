#!/bin/bash
IMAGEM=$(cat $WORKSPACE/IMAGE_FULL.tag)
sed -i.bkp "s|IMAGEM1|${IMAGE_FULL}|g" $WORKSPACE/kubernetes/Deployment.yaml
