#!/bin/bash

sed -i.bkp "s|IMAGEM1|${IMAGE_FULL}|g" $WORKSPACE/kubernetes/Deployment.yaml

# //IMAGEM=$(cat $WORKSPACE/IMAGE_FULL.tag)