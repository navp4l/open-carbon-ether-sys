var EcoToken = artifacts.require("./EcoToken.sol");
module.exports = function(deployer) {
  deployer.deploy(EcoToken);
};