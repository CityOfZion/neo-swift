<p align="center">
  <img 
    src="http://res.cloudinary.com/vidsy/image/upload/v1503160820/CoZ_Icon_DARKBLUE_200x178px_oq0gxm.png" 
    width="125px"
  >
</p>

<h1 align="center">neo-swift</h1>

<p align="center">
  Swift SDK for the <b>NEO</b> blockchain.
</p>

## What is neo-swift

- A swift client for interacting with a node on the [NEO](http://neo.org/) blockchain.
- Written in Swift4 and using Xcode9 Beta
- Primarily meant to be the SDK for iOS and macOS wallet software.
- Underlying cryptographic methods compiled into frameworks via go-mobile.
- [iOS framework](https://github.com/apisit/neo-wallet-address-go)
- [underlying go code](https://github.com/apisit/btckeygenie)

## Current Status

- Implements read operations of neo blockchain
- Allows for send asset transactions
- This is pre-alpha software meant only to be used by experienced developers, use at your own risk

### Supported Methods
```
    enum RPCMethod: String {
        case getBestBlockHash = "getbestblockhash"
        case getBlock = "getblock"
        case getBlockCount = "getblockcount"
        case getBlockHash = "getblockhash"
        case getConnectionCount = "getconnectioncount"
        case getTransaction = "getrawtransaction"
        case getTransactionOutput = "gettxout"
        case getUnconfirmedTransactions = "getrawmempool"
        case sendTransaction = "sendrawtransaction"
        //The following routes can't be invoked by calling an RPC server
        //We must use the wrapper for the nodes made by COZ
        case getBalance = "getbalance"
    }
```

## Things in the pipleine
- NEP2 Support
- Other transaction types
- Better management of dependencies
- Carthage, Cocoapods, and SPM support
- Improved Node/Network Selection
- Improved Documentation

## Quick Start

Clone the repo and open the project in xcode and run all tests in NeoSwiftTests.swift

## Example Usage

```
func demo() {
  // Create an account via a wif string
  let wifPersonA = "L4Ns4Uh4WegsHxgDG49hohAYxuhj41hhxG6owjjTWg95GSrRRbLL" // REMINDER TO NEVER USE THIS FOR REAL FUNDS
  let wifPersonB = "L4sSGSGh15dtocMMSYS115fhZEVN9UuETWDjgGKu2JDu59yncyVf" // REMINDER TO NEVER USE THIS FOR REAL FUNDS
  let accountA = Account(wif: wifPersonA)
  let accountB = Account(wif: wifPersonB)
  print(accountA.wif)
  print(accountA.publicKeyString)
  print(accountA.privateKeyString)
  print(accountA.address)
  print(accountA.hashedSignature) //Data

  accountA.sendAssetTransaction(asset: .gasAssetId, amount: 1, toAddress: accountB.address) { success, error in
            assert(success ?? false)
  }
}
```

## Help

- Open a new [issue](https://github.com/CityOfZion/neo-swift/issues/new) for any problems.
- Send a message to **@andreit1** on the [NEO Slack](https://join.slack.com/t/neoblockchainteam/shared_invite/MjE3ODMxNDUzMDE1LTE1MDA4OTY3NDQtNTMwM2MyMTc2NA).
- If there's a feature you'd like to see included feel free to drop me a line or submit a pull request

## License

- Open-source [MIT](https://github.com/CityOfZion/neo-swift/blob/master/LICENSE).
- Main authors are [@saltyskip](https://github.com/saltyskip) and [@apisit](https://github.com/apisit).
