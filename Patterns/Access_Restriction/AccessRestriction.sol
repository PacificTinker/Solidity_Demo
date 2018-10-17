pragma solidity ^0.4.24;

contract AccessRestriction {

    address public owner = msg.sender;
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
        //The following is executed after the function 
        if (msg.value > _amount) {
            msg.sender.transfer(msg.value - _amount);
        }
    }
    //Uses onlyBy modifier to enforce that owner can only be changed by owner
    function changeOwner(address _newOwner) public onlyBy(owner) {
        owner = _newOwner;
    }
    //Uses onlyAfter and costs modifiers to enforce that the contract can only be bought 
    //at least 4 weeks, note month is not supported in Solidity, after last time this funtion was called 
    //and for greater than 1 ether. The costs modifier also executes code after buyContract is executed
    function buyContract() public payable onlyAfter(lastOwnerChange + 4 weeks) costs(1 ether) {
        owner = msg.sender;
        lastOwnerChange = now;
    }
}
