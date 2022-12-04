async function deployContract() {
    const contract = await ethers.getContractFactory("Poap")
    const deployContract = await contract.deploy()
    await deployContract.deployed()
    // This solves the bug in Mumbai network where the contract address is not the real one
    const txHash = deployContract.deployTransaction.hash
    const txReceipt = await ethers.provider.waitForTransaction(txHash)
    const contractAddress = txReceipt.contractAddress
    console.log("Contract deployed to address:", contractAddress)
}
   
deployContract()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});
