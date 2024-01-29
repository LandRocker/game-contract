const { ethers } = require("hardhat");

async function deploy_game() {
  //deploy LandRocker
  const Game = await ethers.getContractFactory("Game");
  const gameInstance = await upgrades.deployProxy(
    Game,
    [
      "0x0577a2d7242Ee55008fF20d75BeD4dbAebC2664A",
      "0xab4486f450E79011D6540D1fE9c4130d864966aa",
    ],
    {
      kind: "uups",
      initializer: "initializeGame",
    }
  );
 
  await gameInstance.deployed();

  console.log("game Contract deployed to:", gameInstance.address);

  console.log("---------------------------------------------------------");

  return gameInstance;
}

module.exports = deploy_game;
