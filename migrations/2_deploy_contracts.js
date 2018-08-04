let Casino = artifacts.require('./Casino.sol');

module.exports = (deployer) => {
  deployer.deploy(0, 100, {gas: 3000000});
};
