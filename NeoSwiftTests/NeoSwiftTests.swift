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
    let testSeed = "http://test4.cityofzion.io:8880"
    let mainSeed = "http://seed1.neo.org:10332"
    
    func testSendNEP5Transaction() {
        let REAL_WIF_DELETE  = "KxDgvEKzgSBPPfuVfw67oPQBSjidEiqTHURKSDL1R7yGaGYAeYnr" //INSERT A WIF HERE IF YOU WANNA TEST
        guard let accountA = Account(wif: REAL_WIF_DELETE) else {
            assert(false)
            return
        }
        let toAddress = "AXLsAj6AaCMwFAQC8kQuMVxwEXosNebY1f"
        let exp1 = expectation(description: "Wait for transaction one to go through")
        accountA.sendNep5Token(seedURL: "http://localhost:30333", tokenContractHash: "d460914223ae14cba0a890c6a4a9af540dcd2175", decimals: 8, amount: 1, toAddress: toAddress) { success, error, txID in
            assert(success ?? false)
            exp1.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testNetworkMonitor() {
        let network = NEONetworkMonitor.sharedInstance.network
        assert(network != nil)
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
