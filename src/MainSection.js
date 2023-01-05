import { useEffect, useState } from "react";
import { ethers } from "ethers";
// Create new contractABI file and import ABI Remix data to read data from the contract 
import ABI from "./contractABI.json";

function MainSection() {

    // Create state variables to print on the site 
    const [currentAccount, setCurrentAccount] = useState(null);
    const [chainId, setChainId] = useState(null);
    const [chainName, setChainName] = useState(null);
    const [balance, setBalance] = useState(null);
    const [blockNumber, setBlockNumber] = useState(null);

    const [subscribed, setSubscribed] = useState(null);
    const [age, setAge] = useState(null);
    const [name, setName] = useState(null);

    const [doubleAge, setDoubleAge] = useState(null);
    const [addExclamation, setAddExclamation] = useState(null);

    const [input, setInput] = useState(null);

    const change = async () => {
        // console.log("Test");
        // Setting up the contract
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract("0x5312ffB4811D4f467f232aE7B97c8BD8044B7B2d", ABI, signer);

        // const changeAge = await contract.setAge(30);
        const changeName = await contract.setName(input);
        // const changeSubscription = await contract.setSubscribtion();
        const receipt = await changeName.wait();
        console.log(receipt);

    }

    // Creat arrow function that is a variable and get the information of contract   
    const getData = async () => {
        // console.log("Hey");
        // Creates a new Object and autofills it
        // Get the information of wallet
        // Setting up the contract with next 3 lines of code  
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        // Create instance to write to the contract 
        const signer = provider.getSigner();
        // Create instance of contract 1) Address 2) import ABI 3) just created signer variable
        const contract = new ethers.Contract("0x5312ffB4811D4f467f232aE7B97c8BD8044B7B2d", ABI, signer);

        // 1) set a variable 2) await = wait for response 3) call the contract from variable contract 4) call the public state variable from contract
        const areTheySubscribed = await contract.subscribed();
        // console.log(areTheySubscribed.toString());
        // Need to be a toString() to show the output on the page as string otherwise it doesn't show correct 
        setSubscribed(areTheySubscribed.toString());

        const getAge = await contract.age();
        setAge(getAge.toString());

        const getName = await contract.name();
        setName(getName.toString());

        const contractDoubleAge = await contract.doubleAge();
        setDoubleAge(contractDoubleAge.toString());

        const contractAddExclamation = await contract.addExclamation();
        setAddExclamation(contractAddExclamation.toString());

    }

    // Creat arrow function that is a variable and get the information of wallet
    const getWalletAddress = async () => {
        // console.log("Is working");
        // Look for a wallet on the browser 
        if(window.ethereum && window.ethereum.isMetaMask) {
            // console.log("Browser has a wallet");
            // Creates a new Object and autofills it
            // Get the information of wallet 
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            // Looks for accounts on the wallet 
            await provider.send("eth_requestAccounts");
            // Save the provider to a variable 
            const currentAddress = await provider.getSigner().getAddress();
            // console.log(currentAddress);
            // set() chankge the variable 
            setCurrentAccount(currentAddress);

            // getNetwork() get all the data 
            // await wait for the response of network 
            const chain = await provider.getNetwork();
            // set() chankge the variable 
            setChainId(chain.chainId);
            setChainName(chain.name);

            // Get balance 
            // await wait for the response of network 
            const amount = await provider.getBalance(currentAddress);
            // Set the amount to a human readable number 
            const amountInEth = ethers.utils.formatEther(amount);
            // console.log(amountInEth);
            // set() chankge the variable 
            setBalance(amountInEth);

            // Get block number 
            // await wait for the response of network 
            const blockNumber = await provider.getBlockNumber(currentAddress);
            // set() chankge the variable 
            setBlockNumber(blockNumber);
            // console.log(blockNumber);
        }
    }

    const chainChanged = () => {
        // Reloads the website 
        window.location.reload();
    }
    // Listen to Wallet
    window.ethereum.on('chainChanged', chainChanged);
    // Looks for changing accounts 
    window.ethereum.on('accountsChanged', getWalletAddress)

    // Auto updates the page after loading the page
    useEffect(() => {
        getWalletAddress();
    }, []);

    return (
        <div class="MainSection">
            <div class="Content">
                <p>{currentAccount}</p>
                <p>Chain id: {chainId}</p>
                <p>Chain Name: {chainName}</p>
                <p>Eth: {balance}</p>
                <p>Block#: {blockNumber}</p>
                <button onClick={getData}>GET DATA</button>
                <p>subscribed: {subscribed}</p>
                <p>Age: {age}</p>
                <p>Double Age: {doubleAge}</p>
                <p>Name: {name}</p>
                <p>Name!: {addExclamation}</p>
                <input value={input} onInput={e => setInput(e.target.value)} />
                <p> {input} </p>
                <button onClick={change}>Change Data</button>
            </div>
        </div>
    );
}

export default MainSection;