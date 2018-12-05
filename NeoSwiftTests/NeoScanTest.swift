//
//  NeoScanTest.swift
//  NeoSwiftTests
//
//  Created by Apisit Toompakdee on 4/2/18.
//  Copyright © 2018 drei. All rights reserved.
//

import XCTest

class NeoScanTest: XCTestCase {
    
    func testTestNetwork() {
        let exp = expectation(description: "Wait for transaction History response")
        let address = "AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb"
        NeoScan(network: .test).getTransactionHistory(address: address, page: 1) { result, error in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.total_entries ?? 0 >= 407)
                assert(result?.total_pages ?? 0 >= 28)
                assert(result?.page_number == 1)
                assert(result?.entries.count ?? 0 == 15)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetHistory() {
        let exp = expectation(description: "Wait for transaction History response")
        let address = "AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb"
        NeoScan(network: .main).getTransactionHistory(address: address, page: 1) { result, error in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.total_entries ?? 0 >= 407)
                assert(result?.total_pages ?? 0 >= 28)
                assert(result?.page_number == 1)
                assert(result?.entries.count ?? 0 == 15)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetHistoryAccessPageWithoutEntries() {
        let exp = expectation(description: "Wait for transaction History response")
        let address = "AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb"
        NeoScan(network: .main).getTransactionHistory(address: address, page: 100000) { result, error in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.entries.count ?? -1 == 0)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetHistoryTwoAddresses() {
        let exp = expectation(description: "Wait for transaction History between two addressess response")
        let address1 = "AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb"
        let address2 = "ASi48wqdF9avm91pWwdphcAmaDJQkPNdNt"
        NeoScan(network: .main).getTransactionHistory(address1: address1, address2: address2, page: 1) { result, error in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.total_entries ?? 0 >= 13)
                assert(result?.total_pages ?? 0 >= 1)
                assert(result?.page_number == 1)
                assert(result?.entries.count ?? 0 >= 13)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetAllNodes() {
        let exp = expectation(description: "Wait for get all nodes response")
        NeoScan(network: .main).getAllNodes { (result, error) in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.count ?? 0 > 0)
                for node in result! {
                    assert(node.URL.count > 0)
                    assert(node.height > 0)
                }
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBlock() {
        let exp = expectation(description: "Wait for get block response")
        NeoScan(network: .main).getBlock(blockHash: "a1e4d52843cb9e192e8bb4d2deb456b92a32da7ce4432964ced1a858732477cc") { (result, error) in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.version == 0)
                assert(result?.txCount == 6)
                assert(result?.transfers.count == 1)
                assert(result?.transactions.count == 6)
                assert(result?.time == 1544020535)
                assert(result?.size == 2397)
                assert(result?.script.verification == "5521024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d21025bdf3f181f53e9696227843950deb72dcd374ded17c057159513c3d0abe20b6421035e819642a8915a2572f972ddbdbe3042ae6437349295edce9bdc3b8884bbf9a32103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae")
                assert(result?.script.invocation == "40816a6038e9154402dcee59c40daba436c2bcd5632ae47ba83823090d31ba901c88d8260f372c0e9e58fb7c96b1886bbbc7db62eaf64cc469b130cb363b3c0133408826868fdc0b4bec1c1ed639defd269f6fc091bff5542d98af910ae725120c2e66c111b63dbd362f7f992902c1c1fe35df32caf75fd2a2b5d080b4c2ce52a9ce4089ccb124057f875c98ecf68fddbbafa59d03831700ee37208a13df74f96ea066b845dbcaa5a258e93b7b7e41734507c414b5887c5b4f3aefd5860f9063567d8e40f8aacc97ff25d8815a85e6e127fa553969efdbbb5c5cafffa80704653ef88ef066894d8af9b84e22621f71e4a2100535e516b124de493034576b65b8ba77f0a74064241c941a6683f4cf68fb77458d87165b35952e61e093962ef75ab30760a9496053fb2218b7a5cc09fed723a336c08831676c50621a103e91510258a7a52729")
                assert(result?.script.identifier == "275f0e43-acbf-4d54-996a-6325fe3480e7")
                assert(result?.previousblockhash == "")
                assert(result?.nonce == "d9acc3226dd3ecbf")
                assert(result?.nextconsensus == "174e4e04879cfe60ba3b296b1ff08f112f6071756f41b430c2")
                assert(result?.nextblockhash == "")
                assert(result?.merkleroot == "2d3dd563f79b20c38ae2e03005d544852013cb41fadf81689fbf6054a7deed3a")
                assert(result?.index == 3049298)
                assert(result?.blockHash == "a1e4d52843cb9e192e8bb4d2deb456b92a32da7ce4432964ced1a858732477cc")
                assert(result?.confirmations == 1)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetLatestBlockHeight() {
        let exp = expectation(description: "Wait for get latest block height response")
        let expectedMinimumHeight: UInt = 3049368
        NeoScan(network: .main).getLatestBlock { (result, error) in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.height ?? 0 >= expectedMinimumHeight)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetUnclaimed() {
        let exp = expectation(description: "Wait for get unclaimed gas response")
        NeoScan(network: .main).getUnclaimed(address: "AKijMpXc2uPw5dMZ2GMFgUDWJ45H2uEuut") { (result, error) in
            if error == nil {
                #if DEBUG
                print(result as Any)
                #endif
                assert(result?.unclaimed != 0)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
