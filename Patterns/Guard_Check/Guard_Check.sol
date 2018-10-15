pragma solidity^0.4.24;

contract GuardCheck {
    
    function donate(address addr) payable public {
        require(addr != address(0)); //checks if beneficiary address is missing
        require(msg.value != 0); //checks if donation is zero
        //address myAddress = this;
        uint balanceBeforeTransfer = address(this).balance;
        uint transferAmount;
        
        if (addr.balance == 0) {
            transferAmount = msg.value;
        } else if (addr.balance < msg.sender.balance) {
            transferAmount = msg.value / 2;
        } else {
            revert(); //returns donation if beneficiary has more than donor
        }
        
        addr.transfer(transferAmount);
        assert(address(this).balance == balanceBeforeTransfer - transferAmount); //verifies amounts of transaction     
    }
}
