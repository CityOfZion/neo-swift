//
//  Array+Util.swift
//  NeoSwift
//
//  Created by Luís Silva on 26/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

extension Array where Element == UInt8 {
    public var hexString: String {
        return self.map { return String(format: "%x", $0) }.joined()
    }
    
    public var hexStringWithPrefix: String {
        return "0x\(hexString)"
    }
    
    public var fullHexString: String {
        return self.map { return String(format: "%02x", $0) }.joined()
    }
    
    public var fullHexStringWithPrefix: String {
        return "0x\(fullHexString)"
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
