//
//  ScriptBuilderTest.swift
//  NeoSwiftTests
//
//  Created by Ricardo Kobayashi on 20/09/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import XCTest

//reference: neon-js/neon-core/__tests__/sc/ScriptBuilder.ts
class ScriptBuilderTest: XCTestCase {
    func testIntegers() {
        let testCases: [Int: String] = [-1: "4f",
                                        0: "00",
                                        13: "5d",
                                        500: "02f401",
                                        65536: "03000001"]
        let neoScript = ScriptBuilder()
        for key in testCases.keys {
            neoScript.resetScript()
            neoScript.pushData(key)
            #if DEBUG
            print (neoScript.rawBytes.fullHexString)
            #endif
            assert(neoScript.rawBytes.fullHexString == testCases[key])
        }
    }
    
    func testStrings() {
        let case1 = String(repeating: "aa", count: 75)
        let case2 = String(repeating: "aa", count: 0xff)
        let case3 = String(repeating: "aa", count: 0xffff)
        let case4 = String(repeating: "aaaa", count: 0x91a)
        let case5 = String(repeating: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", count: 0x800)
        let testCases: [String: String] = [case1 : String(format: "4b%@", case1),
                                           case2 : String(format: "4cff%@", case2),
                                           case3 : String(format: "4dffff%@", case3),
                                           case4 : String(format: "4d3412%@", case4),
                                           case5 : String(format: "4e00000100%@", case5)]

        let neoScript = ScriptBuilder()
        for key in testCases.keys {
            neoScript.resetScript()
            neoScript.pushData(key)
            #if DEBUG
            print (neoScript.rawBytes.fullHexString)
            #endif
            assert(neoScript.rawBytes.fullHexString == testCases[key])
        }
    }
    
    func testBooleans() {
        let testCases: [Bool: String] = [true : "51",
                                         false : "00"]
        
        let neoScript = ScriptBuilder()
        for key in testCases.keys {
            neoScript.resetScript()
            neoScript.pushData(key)
            #if DEBUG
            print (neoScript.rawBytes.fullHexString)
            #endif
            assert(neoScript.rawBytes.fullHexString == testCases[key])
        }
    }
    
    func testSingleOpCode() {
        let neoScript = ScriptBuilder()
        neoScript.pushData(OpCode.PUSH1)
        #if DEBUG
        print (neoScript.rawBytes.fullHexString)
        #endif
        assert(neoScript.rawBytes.fullHexString == "51")
        
        
    }
}
