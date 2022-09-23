#! /bin/bash

APP_NAME="webappautomation"
RG=$1
SERVER=$2
ENVIRONMENT=$3


# Get acr credentials
CREDENTIALS=$(az acr credential show -n $SERVER)
PASSWORD=$(echo $CREDENTIALS | jq -r ".passwords[0].value")

echo 'Creating Container App'

FQDN=$(az containerapp create \
    --name $APP_NAME \
    --resource-group $RG \
    --image $2.azurecr.io/webapplab \
    --ingress external \
    --target-port 80 \
    --registry-server $SERVER.azurecr.io --registry-username $SERVER --registry-password $PASSWORD \
    --environment $3\
    --query properties.configuration.ingress.fqdn)
