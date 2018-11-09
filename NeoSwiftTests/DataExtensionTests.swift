//
//  DataExtensionTests.swift
//  NeoSwiftTests
//
//  Created by Ricardo Kobayashi on 09/11/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import XCTest

class DataExtensionTests: XCTestCase {
    
    func testDataHexString() {
        //https://codebeautify.org/string-hex-converter
        let data = "A523Z0".data(using: .utf8)
        let value = data?.hexString
        assert(value == "413532335a30")
    }
    
    func testDataHexStringWithPrefix() {
        //https://codebeautify.org/string-hex-converter
        let data = "A523Z0".data(using: .utf8)
        let value = data?.hexStringWithPrefix
        assert(value == "0x413532335a30")
    }
    
    func testDataBytes() {
        //http://www.binaryconvert.com/result_signed_char.html?decimal=052056
        let data = "0".data(using: .utf8)
        let value = data?.bytes
        assert(value?.first == 48)
    }
    
//    func testDataSha256() {
//        let data = "abcabc".data(using: .utf8)
//        let value = data?.sha256
//        let str = String.init(data: value!, encoding: .utf8)
//        assert(str == "bbb59da3af939f7af5f360f2ceb80a496e3bae1cd87dde426db0ae40677e1c2c")
//    }
    
//
//    public var sha256: Data {
//        let bytes = [UInt8](self)
//        return Data(bytes.sha256)
//    }

}
