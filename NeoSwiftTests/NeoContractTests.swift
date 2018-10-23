//
//  NeoContractTests.swift
//  NeoSwiftTests
//
//  Created by Andrei Terentiev on 10/29/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest
import NeoSwift

class NeoContractTests: XCTestCase {
    
    func testInvokeContract() {
        let exp = expectation(description: "Wait for Invoke contract response")
        let client = NeoClient(seed: (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes[0].URL)!)
         //get name of RPX contract
        let script = "00046e616d6567f91d6b7085db7c5aaf09f19eeec1ca3c0db2c6ec"
        client.invokeContract(with: script) { result, error in
            if let response = result {
                #if DEBUG
                print(response)
                #endif
                exp.fulfill()
            }
            else {
                assert(false)
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}

