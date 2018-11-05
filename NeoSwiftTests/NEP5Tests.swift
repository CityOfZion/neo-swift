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
        let REAL_WIF_DELETE  = "KwxrTNGVC62dZ76PeCMnSPgxJdWVNktdvP9scjdvhwLPB9Nr6yDB" 
        let accountA = Account(wif: REAL_WIF_DELETE)
        let toAddress = "AMi3NX8aU9XmcJhWfGs4wqL9LAQ8HZ7rPV"
        let exp1 = expectation(description: "Wait for transaction one to go through")
        accountA?.sendNep5Token(seedURL: "http://chain.simpli.com.br:30333", contractScripthash: "d460914223ae14cba0a890c6a4a9af540dcd2175", decimals: 8, amount: 1, toAddress: toAddress) { success, error, txID in
            assert(success)
            exp1.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testInvokeFunction() {
        let wifToTest  = "KwxrTNGVC62dZ76PeCMnSPgxJdWVNktdvP9scjdvhwLPB9Nr6yDB"
        let accountA = Account(wif: wifToTest)
        let exp1 = expectation(description: "Wait for transaction one to go through")
        accountA?.invokeContractFunction(seedURL: "http://chain.simpli.com.br:30333", method: "feedReef", contractScripthash: "13c05d1ff69d3ad1cbdb89f729da9584893303a9") { (success, error) in
            assert(success)
            exp1.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testNEP5Info() {
        let exp = expectation(description: "Wait for NEP 5 response")
        let client = NeoClient(seed: (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes[0].URL)!)
        //get info RPX
        client.getTokenInfo(with: "ecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9") { (result, error) in
            if let response = result {
                #if DEBUG
                print(response)
                #endif
                exp.fulfill()
                return
            }
            else {
                assert(false)
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testNEP5Balance() {
        let exp = expectation(description: "Wait for NEP 5 response")
        let client = NeoClient(seed: (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes[0].URL)!)
        //get info
        let token = "ecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9"
        client.getTokenBalance(token, address: "AVUSCrS7HNTeY2J64DvpBsrttFArpWEqPR") { result, error in
            if error != nil {
                assert(false)
            }
            else {
                #if DEBUG
                print(result)
                #endif
                XCTAssert(result > 0.0)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testDecodingNEP5Token() {
        let json = """
        {
         "name": "TestName",
         "symbol": "TestSymbol",
         "decimals": 8,
         "totalSupply": 100
        }
        """.data(using: .utf8)!
        
        let token = try! JSONDecoder().decode(NEP5Token.self, from: json)
        
        XCTAssertEqual(token.name, "TestName")
        XCTAssertEqual(token.symbol, "TestSymbol")
        XCTAssertEqual(token.decimals, 8)
        XCTAssertEqual(token.totalSupply, 100)
    }
}
