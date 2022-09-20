#! /bin/bash

RG='rg-vm-webapp'
VM_NAME=$1
ROOT_USER='azureuser'
LOCATION='centralus'

echo 'Creating RG'
az group create --name $RG --location $LOCATION

echo 'Creating VM'
az vm create \
    --name $VM_NAME \
    --resource-group $RG \
    --image 'Canonical:UbuntuServer:18.04-LTS:latest' \
    --location 'centralus' \
    --size 'Standard_B2s' \
    --admin-username $ROOT_USER \
    --generate-ssh-keys \
    --public-ip-sku 'Standard'

VM_STATUS=$(az vm show -g $RG -n $VM_NAME -d --query "provisioningState" --output tsv)
# Wait until VM is ready
while [ "$VM_STATUS" != "Succeeded" ]
do
    sleep 5
    VM_STATUS=$(az vm show -g $RG -n $VM_NAME -d --query "provisioningState" --output tsv)
done


# get IP address and SCP project files
IP=$(az vm list-ip-addresses -g rg-vm-webapp -n myWebAppVM --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" --output TSV)

echo 'Copying Project Files to host'
scp ../../package.json ../../server.js $ROOT_USER@$IP:/home/$ROOT_USER 

echo 'Opening port 80,443 for web app'
az vm open-port \
    -g $RG \
    -n $VM_NAME --port 80,443 \
    --priority 1010 


# Start web app
echo 'Starting Application'

az vm run-command invoke \
    -g $RG \
    -n $VM_NAME \
    --command-id 'RunShellScript' \
    --scripts "sudo apt-get update; sudo apt-get install -y nodejs npm;sudo npm --prefix /home/$ROOT_USER install;sudo nohup node /home/$ROOT_USER/server.js 2>&1 </dev/null &" 

echo "Application running at 'http://$IP'"