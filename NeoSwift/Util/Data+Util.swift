//
//  Data+Util.swift
//  NeoSwift
//
//  Created by Luís Silva on 13/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

extension Data {
    
    // MARK: Hex String
    
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
    
    // MARK: Data to [UInt8]
    
    public var bytes: [UInt8] {
        return [UInt8](self)
    }
}
