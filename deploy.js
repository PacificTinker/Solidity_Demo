const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
  '<put 12 word seed phrase here>',
  'https://rinkeby.infura.io/<put infura key here>'
);
const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  console.log('Attempting to deploy from account ', accounts[0]);
//  console.log('Attempting to deploy interface ', JSON.parse(interface));
  const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: '0x'+bytecode })
    .send({ from: accounts[0] });
  console.log('Contract deployed to ', result.options.address);
};
deploy();
//Contract deployed to  0x18736C32f9AABA59B45732432D20085bcF45b180
