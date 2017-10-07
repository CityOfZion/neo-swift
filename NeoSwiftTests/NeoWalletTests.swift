//
//  NeoWalletTests.swift
//  NeoSwiftTests
//
//  Created by Andrei Terentiev on 9/6/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest
import NeoSwift

class NeoWalletTests: XCTestCase {
    func testExample() {
        guard let a = Account(),
            let b = Account(wif: a.wif) else {
                assert(false)
        }
        assert(a.privateKey == b.privateKey)
    }
}
