const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());
const {interface,bytecode} = require('../compile')

let accounts;
let inbox;
const InitialString = 'Default value'
const ReplacementString = 'Test value'

beforeEach(async() => {
  //get a list of all accounts
  accounts = await web3.eth.getAccounts();
  // Use an accout to deploy contract
  inbox = await new web3.eth.Contract(JSON.parse(interface))
  .deploy({data: bytecode,arguments: [InitialString]})
  .send({from: accounts[0],gas: '1000000'});
});

describe('Inbox',() => {
  it('deploys a contract', () => {
    assert.ok(inbox.options.address);
  });
  it('has a default message', async () => {
    const message = await inbox.methods.message().call();
    assert.equal(message, InitialString);
  });
  it('can change message', async () => {
    await inbox.methods.setMessage(ReplacementString).send({ from: accounts[0] }); //don't need to get hash since it will throw err
    const message = await inbox.methods.message().call();
    assert.equal(message, ReplacementString);
  });
});

/*
class Car {
  park() {
    return 'stopped';
  }
  drive() {
    return 'vroom';
  }
}

let car;
beforeEach(() => {
  car = new Car();
});
describe('Car',() => {
  it('can park',() => {
    assert.equal(car.park(), 'stopped');
  });
  it('can drive',() => {
    assert.equal(car.drive(), 'vroom');
  })
});
*/
