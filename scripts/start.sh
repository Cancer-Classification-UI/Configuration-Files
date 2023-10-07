#!/bin/bash
cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"
APP_PORT=$(grep -oP 'APP_PORT=\K\d+' $SCRIPT_DIR/../web-api/.web-api-env)

# Replace all <APP_PORT> with the actual port number
sed -e "s:<APP_PORT>:$APP_PORT:g" -e "s:<APP_PORT_SMALL>:${APP_PORT: -2}:g" $SCRIPT_DIR/../web-api/template-web-api-config.yaml > $SCRIPT_DIR/../web-api/web-api-config.yaml
sed -e "s:<APP_PORT_SMALL>:${APP_PORT: -2}:g" $SCRIPT_DIR/../template-kind-config.yaml > $SCRIPT_DIR/../kind-config.yaml


# Create cluster
kind create cluster --config $SCRIPT_DIR/../kind-config.yaml --name ccu-cluster

echo "Creating configmaps..."
kubectl create configmap web-api-env --from-file=$SCRIPT_DIR/../web-api/.web-api-env

# Apply web-api config
echo "Applying web-api config..."
kubectl apply -f $SCRIPT_DIR/../web-api/web-api-config.yaml

