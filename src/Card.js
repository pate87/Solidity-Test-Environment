import "./Card.css";
import { useState } from 'react';
import { ethers } from 'ethers';
import ABI from './todoContractABI.json';

function Card(props) {

    const [checked, setChecked] = useState(props.done);

    // function isDone() {
    //     if (props.done == true) {
    //         // return <p>This is Done</p>
    //         return <input type="checkbox" checked />
    //     } else {
    //         // return <p>Not Done</p>
    //         return <input type="checkbox" />
    //     }
    // }

    const toggle = async () => {

        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
            '0x55C98E854c7B80Fd2ed61785C915A8C27c5b5FEa',
            ABI,
            signer
        );

        const toggleTask = await contract.toggleTask(props.id);
        const receipt = await toggleTask.wait();
        if(receipt.confirmations > 0) {
            setChecked(!checked);
        }

    }

    return (
        <div className="ToDoItem">
            <p>{props.Name}</p>
            {/* {isDone()} */}
            <input onClick={toggle} type="checkbox" checked={checked} />
        </div>
    );
}

export default Card;