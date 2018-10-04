//
//  NEP5Tests.swift
//  NeoSwiftTests
//
//  Created by Ricardo Kobayashi on 20/09/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import XCTest

class NEP5Tests: XCTestCase {
    
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
    
    func testNEP5Info() {
        let exp = expectation(description: "Wait for NEP 5 response")
        let client = NeoClient(seed: (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes[0].URL)!)
        //get info RPX
        client.getTokenInfo(with: "ecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9") { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let result):
                print(result)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testNEP5Balance() {
        let exp = expectation(description: "Wait for NEP 5 response")
        let client = NeoClient(seed: (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes[0].URL)!)
        //get info
        let token = "ecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9"
        client.getTokenBalance(token, address: "AVUSCrS7HNTeY2J64DvpBsrttFArpWEqPR") { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let result):
                print(result)
                XCTAssert(result > 0.0)
                exp.fulfill()
                return
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
