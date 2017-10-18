//
//  PBKDF2.swift
//  NeoSwift
//
//  Created by Luís Silva on 22/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import CommonCrypto

struct PBKDF2 {
    static public func deriveKey(password: [UInt8], salt: [UInt8], rounds: UInt32, keyLength: Int) -> [UInt8] {
        var result: [UInt8] = [UInt8](repeating: 0, count: keyLength)
        var status: UInt32 = 0
        let data = Data(password)
        data.withUnsafeBytes { (passwordPtr: UnsafePointer<Int8>) in
            let status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                              passwordPtr,
                                              password.count,
                                              salt,
                                              salt.count,
                                              CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                              rounds,
                                              &result,
                                              keyLength)

            
        }
        return result
    }
}
