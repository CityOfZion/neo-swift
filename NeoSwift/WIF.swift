//
//  WIF.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/23/17.
//  Copyright © 2017 drei. All rights reserved.
//

// Learn more about WIF format here https://en.bitcoin.it/wiki/Wallet_import_format

import Foundation
import SwiftBaseX
import CryptoSwift
    
public extension String {
    func dataWithHexString() -> Data {
        var hex = self
        var data = Data()
        while(hex.characters.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}
