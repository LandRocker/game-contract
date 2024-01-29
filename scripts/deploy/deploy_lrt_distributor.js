const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_lrt_distributor() {
  console.log("Deploying the LRT Distributor contract...");

  const LRTDistributor = await ethers.getContractFactory("LRTDistributor");
    const lrtDistributorInstance = await LRTDistributor.deploy(
      "0x9946F8E0A826CAA042839858ED95180EB6Ce0E9A",
      "0xc6CFD2Cf89A38C1899bb0a97823072147b5943d7"
    );
    await lrtDistributorInstance.deployed();


  console.log("LRT Distributor deployed to:", lrtDistributorInstance.address);
  console.log(
    "---------------------------------------------------------",
  );
  // Let's add laika-sync task here!
  // await hre.run("laika-sync", {
  //   contract: "LRT",
  //   address: lrtInstance.address,
  // });

  return lrtDistributorInstance.address;
}
module.exports = deploy_lrt_distributor;
