#! /bin/bash


SERVER=lolregistry2423

sh CreateResourceGroup.sh
# sh CreateContainerAppEnvironment.sh testappenv rg-container-webapp

CREDENTIALS=$(az acr credential show -n $SERVER)
PASSWORD=$(echo $CREDENTIALS | jq -r ".passwords[0].value")

sh CreateAndUploadWebImage.sh rg-container-webapp $SERVER

az container create \
    --resource-group rg-container-webapp \
    --name testcontainer \
    --image $SERVER.azurecr.io/webapplab \
    --dns-name-label webapp-demo --ports 80 \
    --registry-username $SERVER \
    --registry-password $PASSWORD
# sh CreateContainerApp.sh rg-container-webapp lolregistry2423 testappenv