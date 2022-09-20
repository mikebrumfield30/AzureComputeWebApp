#! /bin/bash

RG='rg-vm-webapp'
IMAGE_NAME=$1
LOCATION='centralus'
RBAC_NAME='VMImage'

echo 'Creating RG'
az group create --name $RG --location $LOCATION


echo 'Creating Service Principal for Packer Execution...'

SUBCRIPTION_ID=$(az account show --query "{ subscription_id: id }" --output tsv)

AD_RESPONSE=$(az ad sp create-for-rbac \
    --role Contributor \
    --name $RBAC_NAME \
    --scopes /subscriptions/$SUBCRIPTION_ID \
    --query "{ client_id: appId, client_secret: password, tenant_id: tenant }") 

echo $AD_RESPONSE

# Get Client ID, Client Secret, Tenant ID for Packer stuff
CLIENT_SECRET=$(echo $AD_RESPONSE | jq -r .client_secret)
CLIENT_ID=$(echo $AD_RESPONSE | jq -r .client_id)
TENANT_ID=$(echo $AD_RESPONSE | jq -r .tenant_id)

echo Id $CLIENT_ID
echo TENANT ID $TENANT_ID
echo CLIENT SECRET $CLIENT_SECRET

echo '{
    "builders": [{
      "type": "azure-arm",
  
      "client_id": "'$CLIENT_ID'",
      "client_secret": "'$CLIENT_SECRET'",
      "tenant_id": "'$TENANT_ID'",
      "subscription_id": "'$SUBCRIPTION_ID'",
      "managed_image_resource_group_name": "'$RG'",
      "managed_image_name": "'$IMAGE_NAME'",
      "os_type": "Linux",
      "image_publisher": "Canonical",
      "image_offer": "UbuntuServer",
      "image_sku": "18.04-LTS",
      "location": "'$LOCATION'",
      "vm_size": "Standard_B2s"
    }],
    "provisioners": [
        {
            "type": "file",
            "source": "../../server.js",
            "destination": "/tmp/server.js"
        },
        {
            "type": "file",
            "source": "../../package.json",
            "destination": "/tmp/package.json"
        },
        {
            "execute_command": "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'",
            "inline": [
                "apt-get update",
                "apt-get upgrade -y",
                "apt-get install -y nodejs npm",
                "chmod 755 /opt",
                "mv /tmp/package.json /opt",
                "mv /tmp/server.js /opt",
                "useradd -m azureuser",
                "npm --prefix /opt install",
        
                "/usr/sbin/waagent -force -deprovision && export HISTSIZE=0 && sync"
            ],
            "inline_shebang": "/bin/sh -x",
            "type": "shell"
        }
    ]
  }' > output.json

echo 'Waiting...'

# exit 1

sleep 120

echo 'Building and Publishing Image'
# packer build -force output.json

packer build -force output.json


echo $IMAGE_NAME 

exit "$?" 
