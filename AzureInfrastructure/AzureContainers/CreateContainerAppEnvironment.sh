#! /bin/bash

APP_ENV_NAME=$1
RG=$2
LOCATION='centralus'

echo 'Creating App env'


az containerapp env create \
    --name $1 \
    --resource-group $RG \
    --location $LOCATION