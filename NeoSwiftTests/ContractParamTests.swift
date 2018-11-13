//
//  ContractParamTests.swift
//  NeoSwiftTests
//
//  Created by Ricardo Kobayashi on 13/11/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import XCTest

//reference: neon-js/neon-core/__tests__/sc/ContractParam.ts
class ContractParamTests: XCTestCase {
    
    func testContractParamLikeWithString() {
        let testCases: [String: Any] =
            [
                "type": "String",
                "value": "1"
            ]
        let result = ContractParam.likeContractParam(testCases)
        assert(result != nil)
        assert(result?.type == ContractParamType.String)
        assert(result?.value as! String == "1")
    }
    
    func testContractParamLikeWithBoolean() {
        let testCases: [String: Any] =
            [
                "type": "Boolean",
                "value": false
            ]
        let result = ContractParam.likeContractParam(testCases)
        assert(result != nil)
        assert(result?.type == ContractParamType.Boolean)
        assert(result?.value as! Bool == false)
    }
    
    func testContractParamLikeWithStringNormalValue() {
        let testCases: [String: Any] =
            [
                "type": "String",
                "value": "test"
        ]
        let result = ContractParam.likeContractParam(testCases)
        assert(result != nil)
        assert(result?.type == ContractParamType.String)
        assert(result?.value as! String == "test")
    }
    
    func testContractParamLikeWithInteger() {
        let testCases: [String: Any] =
            [
                "type": "Integer",
                "value": 10
        ]
        let result = ContractParam.likeContractParam(testCases)
        assert(result != nil)
        assert(result?.type == ContractParamType.Integer)
        assert(result?.value as! Int == 10)
    }
    
    func testContractParamLikeWithHash160() {
        let testCases: [String: Any] =
            [
                "type": "Hash160",
                "value": "cef0c0fdcfe7838eff6ff104f9cdec2922297537"
        ]
        let result = ContractParam.likeContractParam(testCases)
        assert(result != nil)
        assert(result?.type == ContractParamType.Hash160)
        assert((result?.value as! String) == "cef0c0fdcfe7838eff6ff104f9cdec2922297537")
    }
}
