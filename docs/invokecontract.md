---
id: invokecontract
title: Invoke contract
---

## Invoke contract function

After logging with your account, you can call methods from any smart contract, including those where checkwitness is required. 

```
account?.invokeContractFunction(seedURL: "http://18.191.236.185:20333", method: "feedReef", contractScripthash: "13c05d1ff69d3ad1cbdb89f729da9584893303a9")
```

Parameters of this method: 
	- 'seedUrl', is the RPC endpoint where you want to send your request
	- 'method', is the desired method you want to execute \(without parameters\)
	- 'contractScripthash' is the scripthash of the contract you want to execute

Behind the scenes, we create a transaction and sign it using the open account private key.

This is going to call 'sendrawtransaction' RPC function and return a boolean to indicate if method was executed successfully.


## Send NEP-5 Tokens

You can send nep-5 tokens to other accounts.

```
account?.sendNep5Token(seedURL: "http://18.191.236.185:20333", contractScripthash: "d460914223ae14cba0a890c6a4a9af540dcd2175", decimals: 8, amount: 1, toAddress: "AMi3NX8aU9XmcJhWfGs4wqL9LAQ8HZ7rPV")
```

Parameters of this method: 
	- 'seedUrl', is the RPC endpoint where you want to send your request name of method from smart contract and contract scriptHash
	- 'contractScripthash' is the scripthash of the contract you want to execute
	- 'decimals' is provided by the nep-5 contract you. It can be retrieved by executing 'invokeContractFunction' passing 'decimals' as parameters. \(TODO: Automate 'decimals' call\)
	- 'amount' is the amount you want to transfer
	- 'toAddress' is the token recipient (new owner)

This process its similar of 'invokeContractFunction', the main difference is that we are always calling the method "transfer".

