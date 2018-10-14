pragma solidity ^0.4.24;

contract Inbox {
  string public message;

  function Inbox(string intialMessage) public {
    message = intialMessage;
  }

  function setMessage(string newMessage) public {
    message = newMessage;
  }
}
