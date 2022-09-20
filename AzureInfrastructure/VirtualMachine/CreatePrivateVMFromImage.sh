#! /bin/bash


VNET_NAME='vnet-webapp'
RG='rg-vm-webapp'
LOCATION='centralus'

az group create --name $RG --location $LOCATION


# VNet needs: vnet, 2 subnets, nat gateway, public IP, 2 network security groups (for default, to limit inbound to my IP, and an app server subnet, allowing only traffic from the vnet )

az network vnet create \
    -g $RG \
    -n $VNET_NAME \
    -