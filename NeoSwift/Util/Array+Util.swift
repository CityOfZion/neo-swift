//
//  Array+Util.swift
//  NeoSwift
//
//  Created by Luís Silva on 26/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

extension Array where Element == UInt8 {
    
    func toWordArray() -> [UInt32] {
        let input = self
        var words: [UInt32] = []
        for i in 0..<input.count / 4 {
            let offset = i * 4
            let w0 = UInt32(input[offset])
            let w1 = UInt32(input[offset + 1]) << 8
            let w2 = UInt32(input[offset + 2]) << 16
            let w3 = UInt32(input[offset + 3]) << 24
            let w = w0 | w1 | w2 | w3
            words.append(w)
        }
        return words
    }
    
    
    
}

extension Array where Element == UInt32 {
    func toByteArray() -> [UInt8] {
        let input = self
        var bytes: [UInt8] = []
        for i in 0..<input.count {
            let offset = i
            let b0 = UInt8(input[offset] & 0xFF)
            let b1 = UInt8(input[offset] >> 8 & 0xFF)
            let b2 = UInt8(input[offset] >> 16 & 0xFF)
            let b3 = UInt8(input[offset] >> 24 & 0xFF)
            
            bytes.append(contentsOf: [b0,b1,b2,b3])
        }
        return bytes
    }
    
}
