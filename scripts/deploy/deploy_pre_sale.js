const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_lrt_pre_sale() {
  console.log("Deploying LRT Pre sale contracts...");

  //deploy private sale contract
  const LRTPreSale = await ethers.getContractFactory("LRTPreSale");
  const lrtPreSaleInstance = await LRTPreSale.deploy(
    "0xaF769b56ECD463DFD0Da2D7B28D963BB46F03Dd1",
    "0x9946F8E0A826CAA042839858ED95180EB6Ce0E9A"
  );
  await lrtPreSaleInstance.deployed();

  console.log(
    "LRT preSale Contract deployed to:",
    lrtPreSaleInstance.address
  );

  console.log(
    "---------------------------------------------------------",
  );

  // await hre.run("laika-sync", {
  //   contract: "LRTPreSale",
  //   address: lrtPreSaleInstance.address,
  // });

  return lrtPreSaleInstance.address;
}
module.exports = deploy_lrt_pre_sale;
