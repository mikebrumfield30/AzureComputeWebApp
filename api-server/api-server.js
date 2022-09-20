const { DefaultAzureCredential } = require("@azure/identity");
const { ComputeManagementClient } = require("@azure/arm-compute");
const express = require('express')
var cors = require('cors')
const app = express()
app.use(cors())
const port = 3000;

const subscriptionId = process.env.AZURE_SUBSCRIPTION_ID;

const credentials = new DefaultAzureCredential();

const computeClient = new ComputeManagementClient(credentials, subscriptionId);


const listVirtualMachines = async() => {
  console.log(`Lists VMs`)   
  const result = new Array();
  for await (const item of computeClient.virtualMachines.listAll()){
    result.push(item);
  }
  return result;
};

app.get('/', (req, res) => {
    res.send('Hello World!')
  });

app.get('/list_vms', async (req, res) => {
    const vms = await listVirtualMachines();
    var vms_result = [];
    vms.forEach(vm => {
      vms_result.push({
        'name': vm.name,
        'location': vm.location,
        'size': vm.hardwareProfile.vmSize,
        'state': vm.provisioningState
      })
    })

    res.status(200).send(vms_result);
  });

  app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
  })