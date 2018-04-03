//
//  NeoScanTest.swift
//  NeoSwiftTests
//
//  Created by Apisit Toompakdee on 4/2/18.
//  Copyright © 2018 drei. All rights reserved.
//

import XCTest

class NeoScanTest: XCTestCase {

    func testGetClaimableGas() {
        let exp = expectation(description: "Wait for get_claimable response")
        let address = "AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb"
        NeoScan().getClaimableGAS(address: address) { result in
            switch result {
            case .failure:
                assert(false)
            case .success(let claimable):
                print(claimable.claimable)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
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
    
    
    
    
}
