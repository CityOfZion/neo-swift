---
id: invokecontract
title: Chamar contrato
---

## Chamar função do contrato

Após logar com uma conta poderá chamar métodos do smart contract que requer a autenticação através do checkwitness.

```
account?.invokeContractFunction(seedURL: "http://18.191.236.185:20333", method: "feedReef", contractScripthash: "13c05d1ff69d3ad1cbdb89f729da9584893303a9")
```

Parâmetros deste método são: 
	- 'seedUrl', RPC endpoint onde você deseja enviar sua requisição
	- 'method', nome do método que deseja executar \(sem parâmetros\)
	- 'contractScripthash' scripthash do contrato que deseja executar

Dentro do método é criado atributo da transação e será assinado com sua chave para garantir que quem está chamando o método é você mesmo.

Será chamado sendrawtransaction e retornará boolean para saber se a chamada ocorreu com sucesso

## Enviar NEP-5 Tokens

É possível enviar nep5token para outra conta.

```
account?.sendNep5Token(seedURL: "http://18.191.236.185:20333", contractScripthash: "d460914223ae14cba0a890c6a4a9af540dcd2175", decimals: 8, amount: 1, toAddress: "AMi3NX8aU9XmcJhWfGs4wqL9LAQ8HZ7rPV")
```

Parâmetros deste método são: 
	- 'seedUrl', RPC endpoint onde você deseja enviar sua requisição
	- 'contractScripthash' scripthash do contrato que deseja executar
	- 'decimals' é fornecido pela nep-5. É possível obter executando 'invokeContractFunction' passando 'decimals' como parâmetro. \(TODO: Automatizar chamada de 'decimals'\)
	- 'amount' é o valor que deseja transferir
	- 'toAddress' a conta que será transferida o valor 

O processo é similar ao invokeContractFunction, a diferença é que irá chamar o método já previamente definido o "transfer".
