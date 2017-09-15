//
//  SHA256.swift
//  NeoSwift
//
//  Created by Luís Silva on 13/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import CommonCrypto
import Security

extension Data {
    var sha256: Data {
        let bytes = Array<UInt8>(self)
        
        let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        
        CC_SHA256(bytes, CC_LONG(bytes.count), mutablePointer)

        let mutableBufferPointer = UnsafeMutableBufferPointer<UInt8>.init(start: mutablePointer, count: Int(CC_SHA256_DIGEST_LENGTH))
        let sha256Data = Data(buffer: mutableBufferPointer)
        
        mutablePointer.deallocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        
        return sha256Data
    }
}

extension String {
    var sha256: Data? {
        return self.data(using: String.Encoding.utf8)?.sha256
    }
    
}
