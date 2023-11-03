#!/bin/bash
cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

# Web API replacement and setup
APP_PORT=$(grep -oP 'APP_PORT=\K\d+' $SCRIPT_DIR/../web-api/.web-api-env)

sed -e "s:<APP_PORT>:$APP_PORT:g" \
    -e "s:<APP_PORT_SMALL>:${APP_PORT: -2}:g" \
    $SCRIPT_DIR/../web-api/template-web-api-config.yaml > $SCRIPT_DIR/../web-api/web-api-config.yaml

sed -e "s:<APP_PORT_SMALL>:${APP_PORT: -2}:g" \
    $SCRIPT_DIR/../template-kind-config.yaml > $SCRIPT_DIR/../kind-config.yaml

# Login API replacement and setup
APP_PORT=$(grep -oP 'APP_PORT=\K\d+' $SCRIPT_DIR/../login-api/.login-api-env)
MONGO_PORT=$(grep -oP 'MONGODB_REDIRECT=\K.*' $SCRIPT_DIR/../login-api/.login-api-env)
MONGO_URI=$(grep -oP 'MONGODB_URI=\K.*' $SCRIPT_DIR/../login-api/.login-api-env)
MONGO_USERNAME=$(echo $MONGO_URI | awk -F '://' '{print $2}' | awk -F ':' '{print $1}')
MONGO_PASSWORD=$(echo $MONGO_URI | awk -F '://' '{print $2}' | awk -F ':' '{print $2}' | awk -F '@' '{print $1}')

sed -e "s:<APP_PORT>:$APP_PORT:g" \
    -e "s:<MONGO_PORT>:$MONGO_PORT:g" \
    -e "s/<MONGO_ROOT_USERNAME>/$MONGO_USERNAME/g" \
    -e "s/<MONGO_ROOT_PASSWORD>/$MONGO_PASSWORD/g" \
    $SCRIPT_DIR/../login-api/template-login-api-config.yaml > $SCRIPT_DIR/../login-api/login-api-config.yaml

# Create cluster
kind create cluster --config $SCRIPT_DIR/../kind-config.yaml --name ccu-cluster

echo "Creating configmaps..."
kubectl create configmap web-api-env --from-file=.env=$SCRIPT_DIR/../web-api/.web-api-env
kubectl create configmap login-api-env --from-file=.env=$SCRIPT_DIR/../login-api/.login-api-env
kubectl create configmap login-api-db-preload-script --from-file=$SCRIPT_DIR/../login-api/preload/preload.sh
kubectl create configmap login-api-db-preload --from-file=$SCRIPT_DIR/../login-api/preload


# Apply web-api config
echo "Applying deployment configs..."
kubectl apply -f $SCRIPT_DIR/../web-api/web-api-config.yaml
kubectl apply -f $SCRIPT_DIR/../login-api/login-api-config.yaml


