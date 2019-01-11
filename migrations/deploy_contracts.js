var Eyestoken = artifacts.require("./contracts/Eyestoken.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Eyestoken, 'EYE', 'Eyestoken');
};
