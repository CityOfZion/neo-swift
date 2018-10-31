<p align="center">
  <img 
    src="http://res.cloudinary.com/vidsy/image/upload/v1503160820/CoZ_Icon_DARKBLUE_200x178px_oq0gxm.png" 
    width="125px"
  >
</p>

<p align="center">      
  <a href="https://travis-ci.org/CityOfZion/neo-swift">
    <img src="https://travis-ci.org/CityOfZion/neo-swift.svg?branch=master">
  </a>
  <a href="https://codecov.io/gh/CityOfZion/neo-swift">
    <img src="https://codecov.io/gh/CityOfZion/neo-swift/branch/master/graph/badge.svg" />
  </a>
  <a href="https://github.com/CityOfZion/neo-swift/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg">
  </a>
  <a href="https://github.com/Carthage/Carthage">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat">
  </a>
</p>

<h1 align="center">neo-swift</h1>

<p align="center">
  Swift SDK for the <b>NEO</b> blockchain.
</p>

## What is neo-swift

- A swift client for interacting with a node on the [NEO](http://neo.org/) blockchain.
- Written in Swift4 and using Xcode10
- Primarily meant to be the SDK for iOS and macOS wallet software.
- Underlying cryptographic methods compiled into frameworks via go-mobile.
- [iOS framework](https://github.com/apisit/neo-wallet-address-go)
- [underlying go code](https://github.com/apisit/btckeygenie)

## Current Status

- Implements read operations of neo blockchain
- Allows for send asset transactions

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
- Cocoapods, and SPM support
- NEP2 Support
- Use cases
- Documentation
- Other transaction types
- Better management of dependencies
- Improved Node/Network Selection

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate NeoSwift into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "CityOfZion/neo-swift" => 1.0
```

Run `carthage update` to build the framework and drag the built `neo-swift.framework` into your Xcode project.

## Quick Start

Clone the repo and open the project in xcode and run all tests in NeoSwiftTests.swift

## Help

- Open a new [issue](https://github.com/CityOfZion/neo-swift/issues/new) for any problems.
- Send a message to **@Koba** on the [NEO Discord](https://discordapp.com/invite/b8QNXwD).
- If there's a feature you'd like to see included feel free to drop me a line or submit a pull request

## License

- Open-source [MIT](https://github.com/CityOfZion/neo-swift/blob/master/LICENSE).
- Main authors are [@saltyskip](https://github.com/saltyskip) and [@apisit](https://github.com/apisit).
- Collaboration of [O3Labs](https://github.com/O3Labs/OzoneWalletIOS)
