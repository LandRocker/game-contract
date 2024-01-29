const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_game(arInstance,lrtInstance) {
  //deploy LandRocker
  const Game = await ethers.getContractFactory("Game");
  const gameInstance = await upgrades.deployProxy(
    Game,
    [arInstance.address, lrtInstance.address],
    {
      kind: "uups",
      initializer: "initializeGame",
    }
  );

  await gameInstance.deployed();

  return gameInstance;
}

module.exports = deploy_game;
