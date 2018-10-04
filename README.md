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
- Written in Swift4 and using Xcode10 Beta
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
        case getBlockCount = "getblockcount"
        case sendTransaction = "sendrawtransaction"
        case invokeContract = "invokescript"
        case getMemPool = "getrawmempool"
    }
```

## Things in the pipleine
- Carthage, Cocoapods, and SPM support
- NEP2 Support
- Use cases
- Documentation
- Other transaction types
- Better management of dependencies
- Improved Node/Network Selection

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

### Dynamic framework
If you are linking NeoSwift as a Dynamic framework. Create a new “Run Script Phase” in your app’s target’s “Build Phases” and paste the following snippet in the script text field:


```
bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/NeoSwift.framework/strip-frameworks.sh"
```

This step is required to work around an App Store submission bug when archiving universal binaries.



## Help

- Open a new [issue](https://github.com/CityOfZion/neo-swift/issues/new) for any problems.
- Send a message to **@Koba** on the [NEO Discord](https://discordapp.com/invite/b8QNXwD).
- If there's a feature you'd like to see included feel free to drop me a line or submit a pull request

## License

- Open-source [MIT](https://github.com/CityOfZion/neo-swift/blob/master/LICENSE).
- Main authors are [@saltyskip](https://github.com/saltyskip) and [@apisit](https://github.com/apisit).
- Collaboration of [O3Labs](https://github.com/O3Labs/OzoneWalletIOS)
