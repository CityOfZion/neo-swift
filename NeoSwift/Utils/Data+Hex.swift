//
//  Data+Hex.swift
//  NeoSwift
//
//  Created by Luís Silva on 13/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        return self.map { return String(format: "%x", $0) }.joined()
    }
    
    var hexStringWithPrefix: String {
        return "0x\(hexString)"
    }
    
    var fullHexString: String {
        return self.map { return String(format: "%02x", $0) }.joined()
    }
    
    var fullHexStringWithPrefix: String {
        return "0x\(fullHexString)"
    }
}
