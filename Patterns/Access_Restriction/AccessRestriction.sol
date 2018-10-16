pragma solidity ^0.4.24;

contract AccessRestriction {

    address public owner = msg.sender;
    //If you need to test buyContract immediately, change this to - 1 week
    uint public lastOwnerChange = now;
    
    //For use when functions should only be callable under limited circumstances
    //This pattern uses modifier since the restriction might apply to several functions
    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }

    modifier onlyAfter(uint _time) {
        require(now >= _time);
        _;
    }

    modifier costs(uint _amount) {
        require(msg.value >= _amount);
        _;
        if (msg.value > _amount) {
            msg.sender.transfer(msg.value - _amount);
        }
    }
    //Uses onlyBy modifier to enforce that owner can only be changed by owner
    function changeOwner(address _newOwner) public onlyBy(owner) {
        owner = _newOwner;
    }
    //Uses onlyAfter and costs modifiers to enforce that the contract can only be bought 
    //at least one week after last time this funtion was called and for greater than 1 ether 
    function buyContract() public payable onlyAfter(lastOwnerChange + 1 week) costs(1 ether) {
        owner = msg.sender;
        lastOwnerChange = now;
    }
}
