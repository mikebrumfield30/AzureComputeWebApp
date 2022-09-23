#! /bin/bash


RG=$1
REGISTRY_NAME=$2

echo 'Creating Container Registry'

# Create container registry:
az acr create \
    --resource-group $RG \
    --name $REGISTRY_NAME \
    --sku basic \
    --admin-enabled true

# login to Repository in Azure
az acr login --name $REGISTRY_NAME

# compile image locally and push to registry
pushd ../../
docker build --platform=amd64 -t $REGISTRY_NAME.azurecr.io/webapplab .
docker push $REGISTRY_NAME.azurecr.io/webapplab

# output image location details
echo "Image located at $REGISTRY_NAME.azurecr.io/webapplab"
echo "E.g. docker run -p 8080:80 -d $REGISTRY_NAME.azurecr.io/webapplab"