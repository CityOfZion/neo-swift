//
//  Base58Tests.swift
//  NeoSwiftTests
//
//  Created by Luís Silva on 13/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import XCTest

class Base58Tests: XCTestCase {
    func testEncoding() {
        XCTAssertNil("".fromBase58)
        XCTAssertNil([].base58String)
        
        XCTAssert("derp".base58String == "3ZqqXd")
        XCTAssert("1".base58String == "r")
        XCTAssert("the quick brown fox".base58String == "NK2qR8Vz63NeeAJp9XRifbwahu")
        XCTAssert("THE QUICK BROWN FOX".base58String == "GRvKwF9B69ssT67JgRWxPQTZ2X")
        print("3ZqqXd".fromBase58)
        XCTAssert("3ZqqXd".fromBase58 == "derp")
        XCTAssert("r".fromBase58 == "1")
        XCTAssert("NK2qR8Vz63NeeAJp9XRifbwahu".fromBase58 == "the quick brown fox")
        XCTAssert("GRvKwF9B69ssT67JgRWxPQTZ2X".fromBase58 == "THE QUICK BROWN FOX")
    }
    
}
