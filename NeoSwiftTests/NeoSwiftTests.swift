//
//  NeoSwiftTests.swift
//  NeoSwiftTests
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest
import NeoSwift
import Neoutils

class NeoSwiftTests: XCTestCase {
    func testGetBlockCount() {
        let exp = expectation(description: "Wait for block count response")
        
        NeoClient.sharedTest.getBlockCount() { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let count):
                print(count)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBestBlockHash() {
        let exp = expectation(description: "Wait for block hash response")
        
        NeoClient.sharedTest.getBestBlockHash() { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let hash):
                print(hash)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBlockByHash() {
        let exp = expectation(description: "Wait for block hash response")
        
        NeoClient.sharedTest.getBlockBy(hash: "428cbb9661ec83c87a9944feff36d1146467028436e2f69bf57561d3206574c8") { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let block):
                print(block)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBlockByIndex() {
        let exp = expectation(description: "Wait for block hash response")
        
        NeoClient.sharedTest.getBlockBy(index: 42) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let block):
                print(block)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBlockHashByIndex() {
        let exp = expectation(description: "Wait for block hash response")
        NeoClient.sharedTest.getBlockHash(for: 42) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let hash):
                print(hash)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testConnectionCount() {
        let exp = expectation(description: "Wait for connection count response")
        
        NeoClient.sharedTest.getConnectionCount() { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let count):
                print(count)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetMemPool() {
        let exp = expectation(description: "Wait for mem pool response")
        
        NeoClient.sharedTest.getUnconfirmedTransactions() { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let transactions):
                print(transactions)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testTransactionForHash() {
        let exp = expectation(description: "Wait for transaction response")
        
        let hash = "469fe36c464442aa3eecc377f2093ad8594d0e764aad5e4aab5120ed4f3683fc"
        NeoClient.sharedTest.getTransaction(for: hash) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let transaction):
                print(transaction)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testTransactionOutput() {
        let exp = expectation(description: "Wait for block hash response")
        
        let hash = "469fe36c464442aa3eecc377f2093ad8594d0e764aad5e4aab5120ed4f3683fc"
        let index: Int64 = 1
        NeoClient.sharedTest.getTransactionOutput(with: hash, and: index) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let value):
                print(value)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetAssets() {
        let exp = expectation(description: "Wait for asset response")
        
        NeoClient.sharedMain.getAssets(for: "Some address", params: []) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let value):
                print(value)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    //I am exposing the following private keys for testing purposes only
    //Please only use them them to send transactions between each other on
    //the test network, and for the love of god never use them for real funds
    
    // TESTPRIVATEKEY1 -> DO NOT USE FOR REAL FUNDS EVER
    //      d59208b9228bff23009a666262a800f20f9dad38b0d9291f445215a0d4542beb        HEX
    //      L4Ns4Uh4WegsHxgDG49hohAYxuhj41hhxG6owjjTWg95GSrRRbLL                    WIF
    //      AMpupnF6QweQXLfCtF4dR45FDdKbTXkLsr                                  ADDRESS
    //      0398b8d209365a197311d1b288424eaea556f6235f5730598dede5647f6a11d99a   PUBKEY
    // TESTPRIVAATEKEY2 -> DO NOT USE FOR REAL FUNDS EVER
    //      e444ec65fbb94aac0e7fc6bd7f0de64f22513d50c022d3d6e159c24e90b54d8d        HEX
    //      L4sSGSGh15dtocMMSYS115fhZEVN9UuETWDjgGKu2JDu59yncyVf                    WIF
    //      ATLoURz25z4PpsrzZmnowRT3dya44LGEpS                                  ADDRESS
    //      03aa0047673b0bf10f936bb45a909bc70eeef396de934429c796ad496d94911820   PUBKEY
    func testSendNeoTransaction() {
        let wifPersonA = "L4Ns4Uh4WegsHxgDG49hohAYxuhj41hhxG6owjjTWg95GSrRRbLL"
        let wifPersonB = "L4sSGSGh15dtocMMSYS115fhZEVN9UuETWDjgGKu2JDu59yncyVf"
        guard let accountA = Account(wif: wifPersonA),
            let accountB = Account(wif: wifPersonB) else {
                assert(false)
                return
        }
        
        let exp1 = expectation(description: "Wait for transaction one to go through")
        let exp2 = expectation(description: "Wait for transaction two to go through")
        
        accountA.sendAssetTransaction(asset: .neoAssetId, amount: 1, toAddress: accountB.address) { success, error in
            assert(success ?? false)
            exp1.fulfill()
            sleep(10)
            accountB.sendAssetTransaction(asset: .neoAssetId, amount: 1, toAddress: accountA.address) {success, error in
                assert(success ?? false)
                exp2.fulfill()
            }
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    /*
     func testSendGasTransactionWithAttribute() {
     let wifPersonA = "L4Ns4Uh4WegsHxgDG49hohAYxuhj41hhxG6owjjTWg95GSrRRbLL"
     let wifPersonB = "L4sSGSGh15dtocMMSYS115fhZEVN9UuETWDjgGKu2JDu59yncyVf"
     guard let accountA = Account(wif: wifPersonA),
     let accountB = Account(wif: wifPersonB) else {
     assert(false)
     return
     }
     
     let exp1 = expectation(description: "Wait for transaction one to go through")
     let exp2 = expectation(description: "Wait for transaction two to go through")
     
     let attribute = TransactionAttritbute(description: "This is my message when sending gas")
     let attribute2 = TransactionAttritbute(description: "another description attribute")
     accountA.sendAssetTransaction(asset: .gasAssetId, amount: 1, toAddress: accountB.address, attributes: [attribute, attribute2]) { success, error in
     assert(success ?? false)
     exp1.fulfill()
     accountB.sendAssetTransaction(asset: .gasAssetId, amount: 1, toAddress: accountA.address) {success, error in
     assert(success ?? false)
     exp2.fulfill()
     }
     }
     waitForExpectations(timeout: 60, handler: nil)
     }*/
    
    
    func testSendGasTransaction() {
        let wifPersonA = "L4Ns4Uh4WegsHxgDG49hohAYxuhj41hhxG6owjjTWg95GSrRRbLL"
        let wifPersonB = "L4sSGSGh15dtocMMSYS115fhZEVN9UuETWDjgGKu2JDu59yncyVf"
        guard let accountA = Account(wif: wifPersonA),
            let accountB = Account(wif: wifPersonB) else {
                assert(false)
                return
        }
        
        let exp1 = expectation(description: "Wait for transaction one to go through")
        let exp2 = expectation(description: "Wait for transaction two to go through")
        
        accountA.sendAssetTransaction(asset: .gasAssetId, amount: 1, toAddress: accountB.address) { success, error in
            assert(success ?? false)
            exp1.fulfill()
            accountB.sendAssetTransaction(asset: .gasAssetId, amount: 1, toAddress: accountA.address) {success, error in
                assert(success ?? false)
                exp2.fulfill()
            }
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testSendNEP5Transaction() {
        let REAL_WIF_DELETE  = "KxDgvEKzgSBPPfuVfw67oPQBSjidEiqTHURKSDL1R7yGaGYAeYnr" //INSERT A WIF HERE IF YOU WANNA TEST
        guard let accountA = Account(wif: REAL_WIF_DELETE) else {
            assert(false)
            return
        }
        let toAddress = "AXLsAj6AaCMwFAQC8kQuMVxwEXosNebY1f"
        let exp1 = expectation(description: "Wait for transaction one to go through")
        accountA.neoClient = NeoClient(seed: "http://localhost:30333")
        accountA.sendNep5Token(tokenContractHash: "d460914223ae14cba0a890c6a4a9af540dcd2175", amount: 1, toAddress: toAddress) { success, error in
            assert(success ?? false)
            exp1.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testGetClaimsTransaction() {
        let wifPersonA = "L4Ns4Uh4WegsHxgDG49hohAYxuhj41hhxG6owjjTWg95GSrRRbLL"
        guard let accountA = Account(wif: wifPersonA) else {
            assert(false)
            return
        }
        let exp = expectation(description: "Wait for fas claim to complete")
        accountA.claimGas { result, error in
            assert(result!)
            exp.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testGetClaims() {
        let address = "Some Address"
        let exp = expectation(description: "Wait for for claim to complete")
        NeoClient.sharedMain.getClaims(address: address) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let claims):
                print(claims)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testValidateAddress() {
        let exp = expectation(description: "Wait for validate address response")
        NeoClient.sharedTest.validateAddress("AKcm7eABuW1Pjb5HsTwiq7iARSatim9tQ6") { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let isValid):
                print(isValid)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetAccountState() {
        let exp = expectation(description: "Wait for GetAccountState response")
        let address = "AUkVH4k8gPowAEpvQVAmNEkriX96CrKzk9"
        
        NeoClient.sharedTest.getAccountState(for: address) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let accountState):
                print(accountState)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetAssetState() {
        let exp = expectation(description: "Wait for GetAssetState response")
        let asset = "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
        
        NeoClient.sharedTest.getAssetState(for: asset) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let assetState):
                print(assetState)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetTransactionHistory() {
        let exp = expectation(description: "Wait for TransactionHistory Response")
        let address = "AMpupnF6QweQXLfCtF4dR45FDdKbTXkLsr"
        
        NeoClient.sharedTest.getTransactionHistory(for: address) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let history):
                print(history)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testNetworkMonitor() {
        let network = NEONetworkMonitor.sharedInstance.network
        assert(network != nil)
    }
    
    func testOverwriteSeedNode(){
        let client = NeoClient(network: .main, seedURL: (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes[9].URL)!)
        XCTAssertEqual(client.seed, "http://seed5.cityofzion.io:8080")
    }
    
    func testGetPeers() {
        let exp = expectation(description: "Wait for GetPeers Response")
        
        let client = NeoClient(network: .main, seedURL: (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes[9].URL)!)
        client.getPeers { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let peersResult):
                print(peersResult)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetConnectionCount() {
        let exp = expectation(description: "Wait for connection count response")
        
        NeoClient.sharedMain.getConnectionCount() { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let count):
                print(count)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testHash160() {
        let hashedAddress = "AJShjraX4iMJjwVt8WYYzZyGvDMxw6Xfbe".hash160()
        let expected = "bfc469dd56932409677278f6b7422f3e1f34481d"
        XCTAssert(hashedAddress == expected)
    }
    
    func testLittleEndianHexToUInt() {
        let hex = "00e1f505"
        let expected = 100000000
        print(hex.littleEndianHexToUInt)
        XCTAssert(hex.littleEndianHexToUInt == expected)
    }
    
    func testGetBestNodeByResponseTime() {
        let nodes = "http://seed1.neo.org:10332,http://seed2.neo.org:10332,http://seed3.neo.org:10332,http://seed4.neo.org:10332,http://seed5.neo.org:10332,http://seed1.cityofzion.io:8080,http://seed2.cityofzion.io:8080,http://seed3.cityofzion.io:8080,http://seed4.cityofzion.io:8080,http://seed5.cityofzion.io:8080,http://node1.o3.network:10332,http://node2.o3.network:10332"
        let node = NeoutilsSelectBestSeedNode(nodes)
        print(node?.url() as String?, node?.responseTime())
    }
    
    func testGetWhiteListedStatus() {
        let exp = expectation(description: "Wait for NEP 5 response")
        
        let wifPrivateNet = "KxDgvEKzgSBPPfuVfw67oPQBSjidEiqTHURKSDL1R7yGaGYAeYnr"
        guard let privateNetWallet = Account(wif: wifPrivateNet) else {
            assert(false)
            return
        }
        privateNetWallet.neoClient = NeoClient(network: .privateNet, seedURL: "http://localhost:30333")
        
        let scripthash = "b2eb148d3783f60e678e35f2c496de1a2a7ead93"
        privateNetWallet.allowToParticipateInTokenSale(scriptHash: scripthash) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let whitelisted):
                print(whitelisted)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testParticipateTokenSale() {
        let exp = expectation(description: "Wait for testParticipateTokenSale response")
        
        let wifPrivateNet = "L2W3eBvPYMUaxDZGEb395HZf26tLPZgU5qN351HpyVSAG1DWgDtx"
        guard let privateNetWallet = Account(wif: wifPrivateNet) else {
            assert(false)
            return
        }
        let scripthash = "7c1de0a1fba67cbddbfea27aed370ff2ff35e8b2"
        let assetID = AssetId.neoAssetId.rawValue
        let amount = Float64(1)
        let remark = "o3x"
        let networkFee = Float64(0)
        privateNetWallet.neoClient = NeoClient(network: .test, seedURL: "http://seed3.neo.org:20332")
        privateNetWallet.participateTokenSales(scriptHash: scripthash, assetID: assetID, amount: amount, remark: remark, networkFee: networkFee) { success, txID, error in
            assert(success ?? false)
            print(txID)
            if error != nil {
                print(error)
                return
            }
            assert(success ?? false)
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testBaseURL() {
        let url = URL(string: "http://testnet-api.wallet.cityofzion.io/v2/")
        let utxoBaseEndpoint = url?.deletingLastPathComponent().absoluteString
        print(utxoBaseEndpoint)
    }
    
    func testToByteArray() {
        var formatter = NumberFormatter()
        var amount = formatter.number(from: "0.00011550")?.decimalValue
        var intValue = amount! * Decimal(pow(10, 8))
        print(intValue)
        let d = NSDecimalNumber(decimal: intValue).intValue
        let b = toByteArray(d)
        print(b.fullHexString)
    }
}
