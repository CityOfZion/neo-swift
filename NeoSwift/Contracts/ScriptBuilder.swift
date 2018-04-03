//
//  ScriptBuilder.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public class ScriptBuilder {
    private(set) public var rawBytes = [UInt8]()
    var rawHexString: String {
        return rawBytes.fullHexString
    }
    
    public init() {
        rawBytes = []
    }
    
    private func pushOPCode(_ op: OpCode) {
        rawBytes.append(op.rawValue)
    }
    
    private func pushBool(_ boolValue: Bool) {
        pushOPCode(boolValue ? .PUSH1 : .PUSH0)
    }
    
    private func pushInt(_ intValue: Int) {
        switch intValue {
        case -1:
            pushOPCode(.PUSHM1)
        case 0:
            pushOPCode(.PUSH0)
        case 1..<16:
            let rawValue = OpCode.PUSH1.rawValue + UInt8(intValue) - 1
            rawBytes.append(rawValue)
        default:
            let intBytes = toByteArray(intValue)
            pushData(intBytes.fullHexString)
        }
    }
    
    private func pushHexString(_ stringValue: String) {
        let stringBytes = stringValue.dataWithHexString().bytes
        if stringBytes.count < OpCode.PUSHBYTES75.rawValue {
            rawBytes = rawBytes + toByteArrayWithoutTrailingZeros(stringBytes.count)
            rawBytes = rawBytes + stringBytes
        } else if stringBytes.count < 0x100 {
            pushOPCode(.PUSHDATA1)
            rawBytes = rawBytes + toByteArrayWithoutTrailingZeros(stringBytes.count)
            rawBytes = rawBytes + stringBytes
        } else if stringBytes.count < 0x10000 {
            pushOPCode(.PUSHDATA2)
            rawBytes = rawBytes + toByteArrayWithoutTrailingZeros(stringBytes.count)
            rawBytes = rawBytes + stringBytes
        } else {
            pushOPCode(.PUSHDATA4)
            rawBytes = rawBytes + toByteArrayWithoutTrailingZeros(stringBytes.count)
            rawBytes = rawBytes + stringBytes
        }
    }
    
    private func pushArray(_ arrayValue: [Any?]) {
        for elem in arrayValue {
            pushData(elem)
        }
        pushInt(arrayValue.count)
        pushOPCode(.PACK)
    }
    
    public func resetScript() {
        rawBytes.removeAll()
    }
    
    public func pushData(_ data: Any?) {
        if let boolValue = data as? Bool {
            pushBool(boolValue)
        } else if let intValue = data as? Int {
            pushInt(intValue)
        } else if let stringValue = data as? String {
            pushHexString(stringValue)
        } else if let arrayValue = data as? [Any?] {
            pushArray(arrayValue)
        } else if data == nil {
            pushBool(false)
        } else {
            fatalError("Unsupported Data Type Pushed on stack")
        }
    }
    
    public func pushContractInvoke(scriptHash: String, operation: String? = nil, args: Any? = nil, useTailCall: Bool = false) {
        pushData(args)
        
        if let operation = operation {
            let hex = operation.unicodeScalars.filter { $0.isASCII }.map { String(format: "%X", $0.value) }.joined()
            pushData(hex)
        }
        if scriptHash.count != 40 {
            fatalError("Attempting to invoke invalid contract")
        }
        if useTailCall {
            pushOPCode(.TAILCALL)
        } else {
            pushOPCode(.APPCALL)
            let toAppendBytes = scriptHash.dataWithHexString().bytes.reversed()
            rawBytes = rawBytes + toAppendBytes
        }
    }
}
