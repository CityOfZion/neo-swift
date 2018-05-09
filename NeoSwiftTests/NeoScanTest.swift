//
//  NeoScanTest.swift
//  NeoSwiftTests
//
//  Created by Apisit Toompakdee on 4/2/18.
//  Copyright © 2018 drei. All rights reserved.
//

import XCTest

class NeoScanTest: XCTestCase {
    
    func testGetBalance() {
        let exp = expectation(description: "Wait for get_claimable response")
        let address = "AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb"
        NeoScan().getBalance(address: address) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let balance):
                print(balance)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetHistory() {
        let exp = expectation(description: "Wait for transaction History response")
        let address = "AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb"
        NeoScan().getTransactionHistory(address: address, page: 1) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let history):
                print(history)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
