#!/bin/bash
IMAGEM=$(cat $WORKSPACE/IMAGE_FULL.tag)
sed -i.backup "s|IMAGEM1|${IMAGEM}|g" $WORKSPACE/kubernetes/Deployment.yaml
