//
//  ContractResultTests.swift
//  NeoSwiftTests
//
//  Created by Ricardo Kobayashi on 14/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import XCTest

class ContractResultTests: XCTestCase {

    func testeResultArray() {
        var array = [StackEntry]()
        array.append(StackEntry(type: .int, value: "1"))
        let result = StackEntry(type: .array, value: array)
        assert(result.arrayValue.count == 1)
        assert(result.arrayValue[0].intValue == 1)
    }
    
    func testDecodingStackEntryNil() {
        expectFatalError(expectedMessage: "Unknown output from the VM") {
            StackEntry(type: .byteArray, value: true)
        }
    }

}
