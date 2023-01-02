import { useEffect, useState } from "react";
import { ethers } from "ethers";

function MainSection() {

    // Variables to print on the site 
    const [currentAccount, setCurrentAccount] = useState(null);
    const [chainId, setChainId] = useState(null);
    const [chainName, setChainName] = useState(null);
    const [balance, setBalance] = useState(null);
    const [blockNumber, setBlockNumber] = useState(null);

    // Creat arrow function that is a variable 
    const getWalletAddress = async () => {
        // console.log("Is working");
        // Look for a wallet on the browser 
        if(window.ethereum && window.ethereum.isMetaMask) {
            // console.log("Browser has a wallet");
            // Creates a new Object and autofills it 
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
                {/* <button onClick={getWalletAddress}>Connect</button> */}
                <p>{currentAccount}</p>
                <p>Chain id: {chainId}</p>
                <p>Chain Name: {chainName}</p>
                <p>Eth: {balance}</p>
                <p>Block#: {blockNumber}</p>
            </div>
        </div>
    );
}

export default MainSection;