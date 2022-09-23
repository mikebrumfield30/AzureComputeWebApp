#! /bin/bash

RG='rg-container-webapp'
LOCATION='centralus'


echo 'Creating RG....'
az group create -n $RG --location $LOCATION