import { useEffect, useState } from 'react';
import { ethers } from 'ethers';
// Create new contractABI file and import ABI Remix data to read data from the contract
import ABI from './todoContractABI.json';
import Card from './Card.js';

function Todo() {
    // Create state variables to print on the site
    const [currentAccount, setCurrentAccount] = useState(null);
    const [chainName, setChainName] = useState(null);

    // set task variable and set it as an empty array  
    const [task, setTask] = useState([]);

    const [input, setInput] = useState(null);

    const change = async () => {
        // console.log("Test");
        // Setting up the contract
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
            '0x55C98E854c7B80Fd2ed61785C915A8C27c5b5FEa',
            ABI,
            signer
        );

        const createTask = await contract.createTask(input);
    };

    const getData = async () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
            '0x55C98E854c7B80Fd2ed61785C915A8C27c5b5FEa',
            ABI,
            signer
        );

        const total = await contract.totalTasks();
        console.log(total);

        setTask([]);
        for (var i = 0; i < total; i++) {
            const currentTask = await contract.taskList(i);
            // console.log(currentTask.taskName);
            setTask(prevTask => [...prevTask, currentTask]);
        }
        console.log(task);


    };

    // Creat arrow function that is a variable and get the information of wallet
    const getWalletAddress = async () => {
        // console.log("Is working");
        // Look for a wallet on the browser
        if (window.ethereum && window.ethereum.isMetaMask) {
            // console.log("Browser has a wallet");
            // Creates a new Object and autofills it
            // Get the information of wallet
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            // Looks for accounts on the wallet
            await provider.send('eth_requestAccounts');
            // Save the provider to a variable
            const currentAddress = await provider.getSigner().getAddress();
            // console.log(currentAddress);
            // set() chankge the variable
            setCurrentAccount(currentAddress);

            // getNetwork() get all the data
            // await wait for the response of network
            const chain = await provider.getNetwork();
            // set() chankge the variable
            setChainName(chain.name);
        }
    };

    const chainChanged = () => {
        // Reloads the website
        window.location.reload();
    };
    // Listen to Wallet
    window.ethereum.on('chainChanged', chainChanged);
    // Looks for changing accounts
    window.ethereum.on('accountsChanged', getWalletAddress);

    // Auto updates the page after loading the page
    useEffect(() => {
        getWalletAddress();
        getData();
    }, []);

    return (
        <div class="MainSection">
            <div class="Content">
                <p>{currentAccount}</p>
                <p>Chain Name: {chainName}</p>
                <input
                    value={input}
                    onInput={(e) => setInput(e.target.value)}
                />
                <button onClick={change}>Add Task</button>

                {/* Only for test porposes  */}
                {/* <button onClick={getWalletAddress}>Update</button> */}
                {/* <Card Name="Item1" done={true} />
                <Card Name="Item2" done={false} />
                <Card Name="Item3" done={false} /> */}

                {/* Disply an array in React */}
                {/* Creates an new array and loops through it = similar to JS map  */}
                {task.map((item) => (
                    <Card Name={item.taskName} id={item.id} done={item.completedYet} />
                ))}
            </div>
        </div>
    );
}

export default Todo;
