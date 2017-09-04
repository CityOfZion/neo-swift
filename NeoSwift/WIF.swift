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
    func programHashFromAddress() -> String {
        let decoded = try! self.decodeBase58()
        let bytes  = [UInt8](decoded)
        let shortened = bytes[0...20] //need exactly twenty one bytes
        let substringData = Data(bytes: shortened)
        let hashOne = substringData.sha256()
        let hashTwo = hashOne.sha256()
        let bytesTwo = [UInt8](hashTwo)
        let finalKeyData = Data(bytes: shortened[1...shortened.count - 1])
        return finalKeyData.fullHexEncodedString()
    }
    
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
    
    func toWifFromPrivateKey() -> String {
        let decoded = self.lowercased().dataWithHexString()
        var bytes = [UInt8](decoded)
        bytes = [0x80] + bytes
        let hashOne = bytes.sha256()
        let hashTwo = hashOne.sha256()
        let checksum = hashTwo[0...3]
        bytes = bytes + checksum
        let bytesData = Data(bytes: bytes)
        return bytesData.base58EncodedString()
    }
}
