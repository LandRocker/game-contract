const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_planet_stake() {
  console.log("Deploying planetStake contract...");

  const PlanetStake = await ethers.getContractFactory("PlanetStake");
  const planetStakeInstance = await upgrades.deployProxy(
    PlanetStake,
    [
      "0x7A3c66F2F3C16AEbB69373e244846F12eaD9ADe4",
      "0xB21bb1Ab0012236E3CF889FCcE00a4F3d9aF55c4", 
      "0xdF7fE8faec166044819E4E70B983CF0E135016f5"
    ],
    {
      kind: "uups",
      initializer: "__PlanetStake_init",
    }
  );
 
  await planetStakeInstance.deployed();

  console.log("PlanetStake Contract deployed to:", planetStakeInstance.address);
    console.log("---------------------------------------------------------");

  // await hre.run("laika-sync", {
  //   contract: "LRTPreSale",
  //   address: lrtPreSaleInstance.address,
  // });

  return planetStakeInstance.address;
}
module.exports = deploy_planet_stake;
