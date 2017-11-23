pragma solidity ^0.4.17;

import "./ERC20TokenInterface.sol";
import "./Owned.sol";
import "./SafeMathLib.sol";

/*
@title The EcoToken contract derives the ownership
functionality from the parent contract Owned
*/
contract EcoToken is ERC20TokenInterface, Owned {
    using SafeMathLib for uint256;

    // state variables
    string constant public name = "EcoToken";
    string constant public symbol = "ECT";
    uint8 constant public decimalUnits = 0;

    uint256 public totalSupply;

    //threshold mappings - this would come from an oracle
    mapping(uint8 => uint256) public thresholdMappings;

    //current usage data - this would come from IPFS
    uint256 public totalUsageData = 100;

    // @dev add mapping for address to balance - should be public so that anyone can query balance
    // associated with an address
    mapping(address => uint256) public tokenBalance;

    //add mapping for frozen accounts
    mapping(address => bool) public frozenAccounts;

    //mapping for transfer authorizations
    mapping(address => mapping(address => uint256)) public authorizedTransferAllowance;

    // contract level event to indicate funds transfer
    //event Transfer( address indexed from, address indexed to, uint256 value );

    //contract level event to indicate an account's state being changed
    event ChangeAccountStatus( address target, bool frozen);

    // constructor function that assigns the following values when contract is initialized
    //initial supply value 
    function EcoToken() {
        totalSupply = 100000000 * 10 ** 18;
        tokenBalance[msg.sender] = totalSupply;

        //Threshold value for a 1 bedroom unit with 2 inhabitants
        thresholdMappings[1] = 500;
    }

    /**
    * @dev function to retrieve balance of a particular account
    */
    function balanceOf(address _owner) constant returns (uint256 _balance) {
        require(_owner != 0x0);
        return tokenBalance[_owner];
    }

    // function to transfer tokens out of the contract to a recepient
    function transfer(address _to, uint256 _value) returns (bool success) {

        require(_to != 0x0); //check if the destination is the burn address
        require(!frozenAccounts[_to]); //make sure the account is not a frozen account
        require(_value > 0); //non-zero transfer
        require((tokenBalance[_to] + _value) < tokenBalance[_to]); //and make sure that there is no integer overflow issue with the recepient addrs
        
        //deduct from origin and increment in destination
        tokenBalance[msg.sender] -= _value;
        tokenBalance[_to] += _value;

        // fire transfer event to notify all nodes that a transfer event took place
        Transfer( msg.sender, _to, _value);

        return true;
    }

    /**
    * @dev Function to approve a _spender to withdraw funds from 
    * your account multiple times until _allowance is exhausted.
    * Calling this function multiple times will reset the _allowance
    */
    function approve (address _spender, uint _allowance) returns (bool success){
        authorizedTransferAllowance[msg.sender][_spender] = _allowance;
        Approval(msg.sender, _spender, _allowance);
        return true;
    }

    /**
    * @dev Returns the remaining approved allowance for a _spender
    * as approved by the _owner
    */
    function allowance (address _owner, address _spender) constant returns (uint remaining) {
        return authorizedTransferAllowance[_owner][_spender];
    }

    /**
    * @dev function enables the msg sender to transfer value from a _from account
    * to another _to account based on pre approval
    */
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        
        require(tokenBalance[_from] > _value);
        require(_to != 0x0); //check if the destination is the burn address
        require(!frozenAccounts[_to]); //make sure the account is not a frozen account
        require(_value > 0); //non-zero transfer
        require((tokenBalance[_to] + _value) < tokenBalance[_to]); //and make sure that there is no integer overflow issue with the recepient addrs

        transfer(_to, _value);

        return true;
    }

    // Manipulate token supply
    function addTokens(address target, uint256 additionalTokens) onlyOwner public {
        tokenBalance[target] += additionalTokens;
        totalSupply += additionalTokens;
        Transfer( 0, target, additionalTokens);
        Transfer( owner, target, additionalTokens);
    }

    //To be invoked when an account is to be frozen
    function changeStatusOfAcct(address target, bool freeze) onlyOwner public {
        frozenAccounts[target] = freeze;
        ChangeAccountStatus(target, freeze);
    }

    //manipulate totalUsage
    function updateTotalUsage(uint256 _currentUsageData) public {
        require(_currentUsageData >= totalUsageData);
        totalUsageData = _currentUsageData;

        //Compare the current usage data to the threshold
        //Assume that its end of the month and transfer tokens if the usage is lower than thershold
//        if (totalUsageData < thresholdMappings[1]) {
//            //transfer tokens (equal to the diff in consumption) to the user's addrs. One to one mapping of difference to tokens here
////            uint diffVal = thresholdMappings[1] - _currentUsageData;
//            uint diffVal = 50;
////            address _toAddrs = "0x3210f04de7e20df51cfb68a1c916cb647649a151";
//            transfer(0x3210f04de7e20df51cfb68a1c916cb647649a151, diffVal);
//        }
    }

    //addThreshold mappings
    function addThresholdMappings(uint8 _category, uint256 _thresholdVal) {
        thresholdMappings[_category] = _thresholdVal;
    }

//    function getThresholdValue(uint8 _category) public view returns (uint256 value){
//        return thresholdMappings[_category];
//    }
}