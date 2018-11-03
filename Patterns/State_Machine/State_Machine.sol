pragma solidity ^0.4.24;

contract StateMachine {
    
    enum Stages { //using enum to define the sequence of states
        AcceptingBlindBids,
        RevealBids,
        WinnerDetermined,
        Finished
    }

    Stages public stage = Stages.AcceptingBlindBids; //initialize variables
    uint public creationTime = now; //use of now is subject to miner manipulation

    modifier atStage(Stages _stage) {
        require(stage == _stage); //this modifier requies the current stage in the function matches the parameter 
        _;
    }
    
    modifier transitionAfter() {
        _;
        nextStage(); //this causes the internal function incrementing stage to run after the called function
    }
    
    modifier timedTransitions() {
        if (stage == Stages.AcceptingBlindBids && now >= creationTime + 6 days) { //use of now is subject to miner manipulation
            nextStage(); //this causes the internal function incrementing stage to run if 6 days after creation
        }
        if (stage == Stages.RevealBids && now >= creationTime + 10 days) { //use of now is subject to miner manipulation
            nextStage(); //this causes the internal function incrementing stage to run if 10 days after creation
        }
        _;
    }

    function bid() public payable timedTransitions atStage(Stages.AcceptingBlindBids) { 
        //this checks if accepting, transitions if timing is ok, and accepts money for the bid (payable but not shown)
    }

    function reveal() public timedTransitions atStage(Stages.RevealBids) {
        //this checks if revealing bids, transitions if timing is ok and reveals bids (not shown)
    }

    function claimGoods() public timedTransitions atStage(Stages.WinnerDetermined) transitionAfter {
        //this checks if winning bid is determined, transitions if timing is ok, distributes the goods (not shown) and transitions to Finished
    }

    function cleanup() public atStage(Stages.Finished) {
        //this checks if finished and presumably would revert non-winning bids, but it seems to be missing a calling function
    }
    
    function nextStage() internal { //this is an internal function thus can only be called by above functions
        stage = Stages(uint(stage) + 1); //increments the stage, note implicit type conversion
    }
}
