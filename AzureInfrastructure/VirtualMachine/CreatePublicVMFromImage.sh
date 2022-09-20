

IMAGE_NAME=$1
VM_NAME=$2
RG='rg-vm-webapp'


echo 'Creating VM'
az vm create \
    --resource-group $RG \
    --name $VM_NAME \
    --image $1 \
    --admin-username therealmikeb \
    --generate-ssh-keys \
    --public-ip-sku 'Standard'


echo 'Opening port 80,443 for web app'
az vm open-port \
    -g $RG \
    -n $VM_NAME --port 80,443 \
    --priority 1010 

echo 'Starting Application'
az vm run-command invoke \
    -g $RG \
    -n $VM_NAME \
    --command-id 'RunShellScript' \
    --scripts "sudo nohup node /opt/server.js 2>&1 </dev/null &" 


IP=$(az vm list-ip-addresses -g $RG -n $VM_NAME --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" --output TSV)


echo "Application running at 'http://$IP'"
