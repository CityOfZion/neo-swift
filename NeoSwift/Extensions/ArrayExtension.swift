//
//  ArrayExtension.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 10/10/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation
import CommonCrypto

extension Array where Element == UInt8 {
    public var hexString: String {
        return self.map { return String(format: "%02x", $0) }.joined()
    }
    
    public var hexStringWithPrefix: String {
        return "0x\(hexString)"
    }
    
    func toWordArray() -> [UInt32] {
        return arrayUtil_convertArray(self, to: UInt32.self)
    }
    
    mutating public func removeTrailingZeros() {
        for i in (0..<self.endIndex).reversed() {
            guard self[i] == 0 else {
                break
            }
            self.remove(at: i)
        }
    }
    
    func xor(other: [UInt8]) -> [UInt8] {
        assert(self.count == other.count)
        
        var result: [UInt8] = []
        for i in 0..<self.count {
            result.append(self[i] ^ other[i])
        }
        return result
    }
    
    public var base58EncodedString: String {
        guard !self.isEmpty else { return "" }
        return Base58.base58FromBytes(self)
    }
    
    public var base58CheckEncodedString: String {
        var bytes = self
        let checksum = [UInt8](bytes.sha256.sha256[0..<4])
        
        bytes.append(contentsOf: checksum)
        
        return Base58.base58FromBytes(bytes)
    }
    
    public var sha256: [UInt8] {
        let bytes = self
        
        let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        
        CC_SHA256(bytes, CC_LONG(bytes.count), mutablePointer)
        
        let mutableBufferPointer = UnsafeMutableBufferPointer<UInt8>.init(start: mutablePointer, count: Int(CC_SHA256_DIGEST_LENGTH))
        let sha256Data = Data(buffer: mutableBufferPointer)
        
        mutablePointer.deallocate()
        
        return sha256Data.bytes
    }
}

extension Array where Element == UInt32 {
    func toByteArrayFast() -> [UInt8] {
        return arrayUtil_convertArray(self, to: UInt8.self)
    }
    
    func toByteArray() -> [UInt8] {
        return arrayUtil_convertArray(self, to: UInt8.self)
    }
}

func arrayUtil_convertArray<S, T>(_ source: [S], to: T.Type) -> [T] {
    let count = source.count * MemoryLayout<S>.stride/MemoryLayout<T>.stride
    return source.withUnsafeBufferPointer {
        $0.baseAddress!.withMemoryRebound(to: T.self, capacity: count) {
            Array(UnsafeBufferPointer(start: $0, count: count))
        }
    }
}
