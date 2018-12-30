#!/bin/sh
IMAGEM=$(cat $WORKSPACE/IMAGE_FULL.tag)
sed -i.bkp "s|IMAGEM1|$IMAGEM|g" $WORKSPACE/Deployment.yaml
