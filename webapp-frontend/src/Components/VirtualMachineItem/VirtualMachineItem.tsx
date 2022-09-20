import './VirtualMachineItem.css'

export class VirtualMachineData {
    name: string;
    location: string;
    size: string;
    state: string;
    constructor(name: string, location: string, size: string, state: string) {
        this.name = name;
        this.state = state;
        this.location = location;
        this.size = size;
    }
}

function VirtualMachineItem(vm: VirtualMachineData) {
    return (
        <div className='virual_machine_item'>
            <div className='vm_name'>
                <p>{vm.name}</p>
            </div>
            <div className='vm-data-row'>
                <p>Location:</p>
                <p style={{color: '#3a86ff', fontWeight: 700}}>{vm.location}</p>
            </div>
            <div className='vm-data-row'>
                <p>Size:</p>
                <p style={{color: '#8338ec', fontWeight: 700}}>{vm.size}</p>
            </div>
            <div className='vm-data-row'>
                <p>Provisioning State:</p>
                <p style={{color: '#ff006e', fontWeight: 700}}>{vm.state}</p>
            </div>
        </div>
    )
}

// export {VirtualMachineData};
export default VirtualMachineItem;