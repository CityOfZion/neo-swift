//
//  NeoCryptoTests.swift
//  NeoSwiftTests
//
//  Created by Luís Silva on 16/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest

class NeoCryptoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Base58
    
    func testBase58Encoding() {
        XCTAssertNil([].base58String)
        
        XCTAssert("derp".base58String == "3ZqqXd")
        XCTAssert("1".base58String == "r")
        XCTAssert("the quick brown fox".base58String == "NK2qR8Vz63NeeAJp9XRifbwahu")
        XCTAssert("THE QUICK BROWN FOX".base58String == "GRvKwF9B69ssT67JgRWxPQTZ2X")
        
    }
    
    func testBase58Decoding() {
        XCTAssertNil("".fromBase58)
        
        XCTAssert("3ZqqXd".fromBase58 == "derp")
        XCTAssert("r".fromBase58 == "1")
        XCTAssert("NK2qR8Vz63NeeAJp9XRifbwahu".fromBase58 == "the quick brown fox")
        XCTAssert("GRvKwF9B69ssT67JgRWxPQTZ2X".fromBase58 == "THE QUICK BROWN FOX")
    }
    
    // MARK: - SHA256
    
    func testSHA256() {
        XCTAssert("".sha256?.fullHexString == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
        XCTAssert("NEO".sha256?.fullHexString == "1a259dba256600620c6c91094f3a300b30f0cbaecee19c6114deffd3288957d7")
        XCTAssert("Smart Economy".sha256?.fullHexString == "6c4cb281896c7779f4e2800471638026d52178b2556a0a3fbc3673368ba97385")
    }
}
