//
//  WIFTest.swift
//  NeoSwiftTests
//
//  Created by Andrei Terentiev on 8/24/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest
import NeoSwift
import Security


class WIFTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testToWifFromPrivateKey() {
        let pkey = "0C28FCA386C7A227600B2FE50B7CAE11EC86D3BF1FBE471BE89827E19D72AA1D"
        assert(pkey.toWifFromPrivateKey() == "5HueCGU8rMjxEXxiPuD5BDku4MkFqeZyd4dZ1jvhTVqvbTLvyTJ")
    }
    
    func testToPrivateKeyFromWif() {
        let wif = "KzULqzStT2tseGnqogXnTLG5NCT1YXa3F9Wp1Kdv9xMxFhvV6H2A"
        let derp = wif.toPrivateKeyFromWif().uppercased()
        print(derp)
        assert (wif.toPrivateKeyFromWif().uppercased() == "0C28FCA386C7A227600B2FE50B7CAE11EC86D3BF1FBE471BE89827E19D72AA1D")
    }
    
    func testWalletGenerator() {
        let wallet = Account(wif: "KzULqzStT2tseGnqogXnTLG5NCT1YXa3F9Wp1Kdv9xMxFhvV6H2A")
        print(wallet)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
