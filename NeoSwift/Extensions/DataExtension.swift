//
//  DataExtension.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 10/10/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

extension Data {
    
    public var hexString: String {
        return self.map { return String(format: "%02x", $0) }.joined()
    }
    
    public var hexStringWithPrefix: String {
        return "0x\(hexString)"
    }
    
    public var bytes: [UInt8] {
        return [UInt8](self)
    }
    
    public var sha256: Data {
        let bytes = [UInt8](self)
        return Data(bytes.sha256)
    }
}
