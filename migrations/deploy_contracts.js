var Eyestoken = artifacts.require("./constracts/Eyestoken.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Eyestoken, 'EYE', 'Eyestoken');
};
