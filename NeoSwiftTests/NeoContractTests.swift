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
            //print (neoScript.rawBytes)
            print (neoScript.rawBytes.fullHexString)
            assert(neoScript.rawBytes.fullHexString == testCases[key])
        }
    }
    
    func testContract() {
        let testCases: [[String: Any?]] =
                [["script": "00c1046e616d65675f0e5a86edd8e1f62b68d2b3f7c0a761fc5a67dc",
                "scriptHash": "dc675afc61a7c0f7b3d2682bf6e1d8ed865a0e5f",
                "operation": "name",
                "args": []
             ],
             [
                "script": "000673796d626f6c6711c4d1f4fba619f2628870d36e3a9773e874705b",
                "scriptHash": "5b7074e873973a6ed3708862f219a6fbf4d1c411",
                "operation": "symbol",
                "args": nil
            ],
            [
                "script": "0008646563696d616c736711c4d1f4fba619f2628870d36e3a9773e874705b",
                "scriptHash": "5b7074e873973a6ed3708862f219a6fbf4d1c411",
                "operation": "decimals",
                "args": false
            ],
            [
                "script": "205fe459481de7b82f0636542ffe5445072f9357a1261515d6d3173c07c762743b51c10962616c616e63654f666711c4d1f4fba619f2628870d36e3a9773e874705b",
                "scriptHash": "5b7074e873973a6ed3708862f219a6fbf4d1c411",
                "operation": "balanceOf",
                "args": ["5fe459481de7b82f0636542ffe5445072f9357a1261515d6d3173c07c762743b"]
            ],
            [
                "script": "5767b7040c106561763ce38c0ce658a946e5d1b381db",
                "scriptHash": "db81b3d1e546a958e60c8ce33c766165100c04b7",
                "operation": nil,
                "args": 7
            ]]
        let neoScript = ScriptBuilder()
        for testCase in testCases {
            guard let script = testCase["script"] as? String,
                let scriptHash = testCase["scriptHash"] as? String else {
                    fatalError("Coud not parse test cases")
            }
            let operation = testCase["operation"] as? String
            let args = testCase["args"] ?? nil
            neoScript.pushContractInvoke(scriptHash: scriptHash, operation: operation, args: args)
            print (neoScript.rawBytes.fullHexString)
            assert(neoScript.rawBytes.fullHexString == script)
            neoScript.resetScript()
        }
    }
}

