//
//  AES.swift
//  NeoSwift
//
//  Created by Luís Silva on 21/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import CommonCrypto

@objc public class AES: NSObject {
    @objc public enum KeySize: Int {
        case keySize128 = 128
        case keySize192 = 192
        case keySize256 = 256
        
        var kCCKeySize: Int {
            switch self {
            case .keySize128: return kCCKeySizeAES128
            case .keySize192: return kCCKeySizeAES192
            case .keySize256: return kCCKeySizeAES256
            }
        }
    }
    
    @objc static public func encrypt(bytes: [UInt8], key: [UInt8], keySize: KeySize, pkcs7Padding: Bool) -> [UInt8] {
        assert(keySize.rawValue / 8 <= key.count)
        
        let options = kCCOptionECBMode | (pkcs7Padding ? kCCOptionPKCS7Padding : 0)
        
        let resultSize = bytes.count + 16
        
        var result: [UInt8] = Array(repeatElement(0, count: resultSize))
        var numBytesEncrypted = 0
        
        let status = CCCrypt(CCOperation(kCCEncrypt),
                             CCAlgorithm(kCCAlgorithmAES),
                             CCOptions(options),
                             key,
                             keySize.kCCKeySize,
                             nil,
                             bytes,
                             bytes.count,
                             &result,
                             resultSize,
                             &numBytesEncrypted)
        
        guard status == 0 else { return [] }
        
        result.removeLast(resultSize - numBytesEncrypted)
        return result
    }
    
    @objc static public func decrypt(bytes: [UInt8], key: [UInt8], keySize: KeySize, pkcs7Padding: Bool) -> [UInt8] {
        assert(keySize.rawValue / 8 <= key.count)
        
        let options = kCCOptionECBMode | (pkcs7Padding ? kCCOptionPKCS7Padding : 0)
        
        let resultSize = bytes.count
        
        var result: [UInt8] = Array(repeatElement(0, count: resultSize))
        var numBytesEncrypted = 0
        
        let status = CCCrypt(CCOperation(kCCDecrypt),
                             CCAlgorithm(kCCAlgorithmAES),
                             CCOptions(options),
                             key,
                             keySize.kCCKeySize,
                             nil,
                             bytes,
                             bytes.count,
                             &result,
                             resultSize,
                             &numBytesEncrypted)
        
        guard status == 0 else { return [] }
        
        result.removeLast(resultSize - numBytesEncrypted)
        return result
        
    }
}
