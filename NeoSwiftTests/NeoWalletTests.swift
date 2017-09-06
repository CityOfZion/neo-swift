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
        let a = Account()
        let b = Account(wif: a.wif)
        assert(a.privateKey == b.privateKey)
    }
}
