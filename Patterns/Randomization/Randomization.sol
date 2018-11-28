pragma solidity ^0.4.24;
contract Randomnization {

    bytes32 sealedSeed; //seed to be provided by a trusted party, i.e., contract creator
    bool seedSet = false;
    bool betsClosed = false;
    uint storedBlockNumber; //block number in chain
    address trustedParty = 0xf01171c1273E826C27F5E058AF0d146733A7133c; //use trusted party's eth acct address

    function bet() public payable{
        require(!betsClosed); //betting must not be closed yet
        // Add betting logic here
        betMade = true;
    }

    function setSealedSeed(bytes32 _sealedSeed) public {
        require(!seedSet); //seed must not be set already to prevent re-initialization
        require (msg.sender == trustedParty); //check that call is from trusted party
        betsClosed = true; //close betting
        sealedSeed = _sealedSeed; //I think this is meant to be keccak256(msg.sender, _sealedSeed)
        storedBlockNumber = block.number + 1; //increments current block number by 1
        seedSet = true;
    }

    function reveal(bytes32 _seed) public {
        require(seedSet);
        require(betMade);
        require(storedBlockNumber < block.number);
        require(keccak256(msg.sender, _seed) == sealedSeed); //check that hash of conflated sender address and seed equals the sealed seed
        uint random = uint(keccak256(_seed, blockhash(storedBlockNumber)));
        // Insert logic for usage of random number here;
        seedSet = false; //reset the contract
        betsClosed = false;
    }
}
