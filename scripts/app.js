// Import libraries
var Web3            = require('web3'),
    contract        = require("truffle-contract"),
    path            = require('path')
    MyContractJSON  = require('../build/contracts/EcoToken.json');

// Setup RPC connection   
var endpoint = 'http://localhost:8555';

var fromAddrs = "0x78f09b3ed70eaca564825306c37a19f9417011c4";
var addrs2 = "0x2cdd5eebe58eff29d0cca2971cdddc9fb941faa4";

var fromAddrsPri = "0a668ea2328a9d09badc94c009c049e1683c5610aab89c9401b6aad9eb53d775";
var addrs2Pri = "0249f5865121b1cdc9bfc8639c89d0b3029a6431adc67404e32165b9f5c03312";

var web3 = new Web3(provider);
var provider = new Web3.providers.HttpProvider("http://localhost:8545");

var ecoTokenContractInst = contract(MyContractJSON);
ecoTokenContractInst.setProvider(provider);
//
//// Get eth.coinbase balance
//ecoTokenContractInst.deployed().then(function(instance) {
//    return instance.balanceOf.call(fromAddrs, {from: fromAddrs});
//
//}).then(function(result) {
//    console.log("Balance of account " + fromAddrs + " is " + web3.fromWei(result.toNumber(), "ether"));
//
//}, function(error) {
//    console.log(error);
//});

// Get threshold val
ecoTokenContractInst.deployed().then(function(instance) {
    return instance.thresholdMappings.call(1, {from: fromAddrs});

}).then(function(result) {
    console.log("Threshold value when getting threshold val is " + result.toNumber());

}, function(error) {
    console.log(error);
});


// Get totalSupply
ecoTokenContractInst.deployed().then(function(instance) {
    return instance.totalSupply.call({from: fromAddrs});

}).then(function(result) {
    console.log("Total supply is " + web3.fromWei(result, "ether"));

}, function(error) {
    console.log(error);
});

// Get totalUsage
ecoTokenContractInst.deployed().then(function(instance) {
    return instance.totalUsageData.call({from: fromAddrs});

}).then(function(result) {
    console.log("Total usage data is " + result);

}, function(error) {
    console.log(error);
});

// Update totalUsage
var createInstance = function() {
 return new Promise(function (resolve, reject) {
    resolve(ecoTokenContractInst.deployed());
 });
}

var updateTotalUsage = function(instance) {
 return new Promise(function (resolve, reject) {
    instance = ecoTokenContractInst.deployed();
    resolve(instance);
 });
}

ecoTokenContractInst.deployed().then(function(instance) {
    instance.updateTotalUsage.sendTransaction(200, {from: addrs2});
    return instance;
}).then(function(instance) {
    return instance.totalUsageData.call({from: fromAddrs});
}, function(error) {
     console.log(error);
}).then(function(result){
    console.log("Updated Total usage data is " + result);
}, function(error) {
    console.log(error);
});

// Add threshold
ecoTokenContractInst.deployed().then(function(instance) {
    instance.addThresholdMappings.sendTransaction(2, 1000, {from: fromAddrs});
    return instance;

}).then(function(instance) {
      return instance.thresholdMappings.call(2, {from: fromAddrs});

}).then(function(result) {
    console.log("Threshold value when doing combination op is " + result);

}, function(error) {
    console.log(error);
});
