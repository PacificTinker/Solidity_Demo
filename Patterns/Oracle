pragma solidity ^0.4.24;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol"; //May need to import ABI directly

contract OracleExample is usingOraclize { //declares inheritance from the imported ABI

    string public EURUSD;
    // you can have event handlers here for initial, price update and query

    function updatePrice() public payable { //caller must pay gas and query cost
        if (oraclize_getPrice("URL") > this.balance) {
            //test for sufficient funds
        } else {
            //this is the query, you need to provide an API key
            oraclize_query("URL", "json(http://api.fixer.io/latest?symbols=USD).rates.EUR");
        }
    }
    
    function __callback(bytes32 myid, string result) public {
        require(msg.sender != oraclize_cbAddress()); //makes sure the calling entity is oracalize
        EURUSD = result; //result saved in storage
    }
}
