//
//  NumberExtesion.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 27/07/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

public extension Int {
    func toHexString() -> String {
        return String(format:"%02X", self)
    }
}

public extension UInt16 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
}

public extension Int32 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int32>.size)
    }
}
