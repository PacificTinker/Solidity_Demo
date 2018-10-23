pragma solidity ^0.4.24;

contract Proxy { //Also known as a dispatcher

    address public delegate; //This is the address of the delegate contract module 
    address owner = msg.sender;

    function upgradeDelegate(address newDelegateAddress) public {
        require(msg.sender == owner);
        delegate = newDelegateAddress; //This reassigns the delegate to the new contract address
    }

    function() external payable { //Unnamed so any call other than upgradeDelegate will call it
        //The following is Solidity inline assembly the use of which is generally
        //discouraged unless you really know what you are doing
        assembly {
            let _target := sload(0) //Stores first variable
            calldatacopy(0x0, 0x0, calldatasize) //Copies function signature and params into memory
            let result := delegatecall(gas, _target, 0x0, calldatasize, 0x0, 0) //result is bool outcome
            returndatacopy(0x0, 0x0, returndatasize)
            switch result case 0 {revert(0, 0)} default {return (0, returndatasize)} //Reverts negative outcome or returns result
        }
    }
}

//The delegate contract can be any ordinary contract as it does not know it is being called by 
//a proxy. Care must be taken to maintain the order of storage and only additions are possible
