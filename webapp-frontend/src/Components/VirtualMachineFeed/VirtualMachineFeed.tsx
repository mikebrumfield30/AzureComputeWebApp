import { useEffect, useState } from 'react'
import { VirtualMachineData } from '../VirtualMachineItem/VirtualMachineItem';
import VirtualMachineItem from '../VirtualMachineItem/VirtualMachineItem';
import './VirtualMachineFeed.css'




export default function VirtualMachineFeed() {

    const [error, setError] = useState(null);
    const [isLoaded, setIsLoaded] = useState(false);
    const [virtualMachines, setVirtualMachines] = useState<VirtualMachineData[]>([]);
    useEffect(() => {
        const endpoint: string = 'http://localhost:3000/list_vms';
        fetch(endpoint)
        .then(res => res.json())
        .then(
            (result) => {
                setIsLoaded(true);
                setVirtualMachines(result);
            },
            (error) => {
                console.log(error)
                setError(error)
            }
        )
    }, virtualMachines)
    if(!isLoaded) {
        return (
            <div>
                Loading...
            </div>
        )
    }
    else if(error) {
        return (
            <div>
                Something went wrong
            </div>
        )
    }
    else {
        if(virtualMachines.length === 0) {
            return (
                <div className='virtual_machine_feed'>
                    <h1>No Virtual Machines Running...</h1>
                </div>
            )
        }
        else if(virtualMachines.length === 1) {
            const sample_vm = virtualMachines[0]
            return (
                <div className='virtual_machine_feed'>
                    <h1>You have {virtualMachines.length} Virtual Machine Deployed</h1>
                    <VirtualMachineItem {...sample_vm}></VirtualMachineItem>
                </div>
            )
        }
        // const vm = new VirtualMachineData(); 
        else {
            const feedItems = virtualMachines.map((vm) => <VirtualMachineItem {...vm}></VirtualMachineItem>);
            return (
                <div className='virtual_machine_feed'>
                    <h1>You have {virtualMachines.length} Virtual Machines Deployed</h1>
                    {feedItems}
                </div>
            )
        }
    }
}