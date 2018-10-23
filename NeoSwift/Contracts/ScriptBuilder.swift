//
//  ScriptBuilder.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

@objc public class ScriptBuilder: NSObject {
    private(set) public var rawBytes = [UInt8]()
    var rawHexString: String {
        return rawBytes.fullHexString
    }
    
    public override init() {
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
            let intBytes = toByteArrayWithoutTrailingZeros(intValue)
            pushHexString(intBytes.fullHexString)
        }
    }
    
    private func pushHexString(_ stringValue: String) {
        let stringBytes = stringValue.dataWithHexString().bytes
        pushBytes(stringBytes)
    }
    
    private func pushBytes(_ stringBytes: [UInt8]) {
        let size = stringBytes.count
        if stringBytes.count <= OpCode.PUSHBYTES75.rawValue {
            rawBytes = rawBytes + size.toHexString().dataWithHexString().bytes
            rawBytes += stringBytes
        } else if stringBytes.count < 0x100 {
            pushOPCode(.PUSHDATA1)
            rawBytes = rawBytes + size.toHexString().dataWithHexString().bytes
            rawBytes += stringBytes
        } else if stringBytes.count < 0x10000 {
            pushOPCode(.PUSHDATA2)
            let sizeUInt16: UInt16 = UInt16(size)
            rawBytes = rawBytes + sizeUInt16.data.bytes
            rawBytes += stringBytes
        } else {
            pushOPCode(.PUSHDATA4)
            let sizeInt32: Int32 = Int32(size)
            rawBytes = rawBytes + sizeInt32.data.bytes
            rawBytes += stringBytes
        }
    }
    
    private func pushArray(_ arrayValue: [Any?]) {
        for elem in arrayValue {
            pushData(elem)
        }
        pushInt(arrayValue.count)
        pushOPCode(.PACK)
    }
    
    private func pushParam(_ data: ContractParam) {
        switch data.type {
        case .String:
            if let stringValue = data.value as? String {
                pushHexString(stringValue)
            }
            break
        case .Boolean:
            if let boolValue = data.value as? Bool {
                pushBool(boolValue)
            }
            break
        case .Integer:
            if let intValue = data.value as? Int {
                pushInt(intValue)
            }
            break
        case .ByteArray:
            if let stringValue = data.value as? String {
                pushHexString(stringValue)
            }
            break
        case .Array:
            if let arrayValue = data.value as? [Any?] {
                pushArray(arrayValue)
            }
            break
        case .Hash160:
            if let stringValue = data.value as? String {
                pushBytes(stringValue.dataWithHexString().bytes.reversed())
            }
            break
        default:
            fatalError("Unsupported Data Type Pushed on stack")
            break
        }
    }
    
    @objc public func resetScript() {
        rawBytes.removeAll()
    }
    
    @objc public func pushData(_ data: Any?) {
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
        } else if let opcodeValue = data as? OpCode {
            pushOPCode(opcodeValue)
//        } else if let mapValue = data as? [String:Any], let contractParam = ContractParam.likeContractParam(mapValue) {
//            pushParam(contractParam)
        } else {
            fatalError("Unsupported Data Type Pushed on stack")
        }
    }
    
    @objc public func pushContractInvoke(scriptHash: String, operation: String? = nil, args: Any? = nil, useTailCall: Bool = false) {
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
            rawBytes += toAppendBytes
        }
    }
}
