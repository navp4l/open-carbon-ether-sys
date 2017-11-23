var Web3 = require('web3');
var util = require('ethereumjs-util');
var tx = require('ethereumjs-tx');
var lightwallet = require('eth-lightwallet');
var txutils = lightwallet.txutils;

var endpoint = 'http://localhost:8555';

var fromAddrs = "0x4b8d02a91ec030ce3ef12ddb16e5a3def04b99ae";

var web3 = new Web3(
    new Web3.providers.HttpProvider(endpoint)
);

var ecoTokenContractABI = require("../ABI/EcoToken.json");

var ecoTokenContractAddrs = "0xc97896422a848d6161878ae3d609619754f2ae52";

var ecoTokenContractInst = web3.eth.contract(ecoTokenContractABI).at(ecoTokenContractAddrs);


async function parentFunction(contract, methodName, ...args) {
  return new Promise( (resolve, reject) => {
    contract[methodName](...args, (err, result) => {
      if (!err) resolve(result);
      else reject(err);
    });
  });
}


async function run() {

console.log(ecoTokenContractInst);

let _balanceOf = await parentFunction(ecoTokenContractInst, "balanceOf", fromAddrs);

//let totalSupply = await parentFunction(ecoTokenContractInst, "balanceOf", fromAddrs);

//let totalSupply = web3.eth.call({from : fromAddrs, to : ecoTokenContractAddrs, data: callData})

console.log(`balanceOf is ${_balanceOf}`);

//let totalUsage = await

process.exit(0);

}

run().catch(console.error);