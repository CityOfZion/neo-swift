//
//  StringExtension.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 10/10/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    public var base58EncodedString: String {
        return [UInt8](utf8).base58EncodedString
    }
    
    public var base58DecodedData: Data? {
        let bytes = Base58.bytesFromBase58(self)
        return Data(bytes)
    }
    
    public var base58CheckDecodedData: Data? {
        guard let bytes = self.base58CheckDecodedBytes else { return nil }
        return Data(bytes)
    }
    
    public var base58CheckDecodedBytes: [UInt8]? {
        var bytes = Base58.bytesFromBase58(self)
        guard 4 <= bytes.count else { return nil }
        
        let checksum = [UInt8](bytes[bytes.count-4..<bytes.count])
        bytes = [UInt8](bytes[0..<bytes.count-4])
        
        let calculatedChecksum = [UInt8](bytes.sha256.sha256[0...3])
        if checksum != calculatedChecksum { return nil }
        
        return bytes
    }
    
    public var littleEndianHexToUInt: UInt {
        let str = self.dataWithHexString().bytes.reversed().hexString
        return UInt(str, radix: 16)!
    }
    
    public var sha256: Data? {
        return self.data(using: String.Encoding.utf8)?.sha256
    }
    
    func hash160() -> String? {
        //NEO Address hash160
        //skip the first byte which is 0x17, revert it then convert to full hex
        let bytes = self.base58CheckDecodedBytes!
        let reverse = Data(bytes: bytes[1...bytes.count - 1].reversed())
        return reverse.hexString
    }
    
    func hashFromAddress() -> String {
        let bytes = self.base58CheckDecodedBytes!
        let shortened = bytes[0...20] //need exactly twenty one bytes
        let substringData = Data(bytes: shortened)
        let hashOne = substringData.sha256
        let hashTwo = hashOne.sha256
        _ = [UInt8](hashTwo)
        let finalKeyData = Data(bytes: shortened[1...shortened.count - 1])
        return finalKeyData.hexString
    }
    
    func scriptHash() -> Data {
        let bytes = self.base58CheckDecodedBytes!
        let shortened = bytes[0...20] //need exactly twenty one bytes
        let substringData = Data(bytes: shortened)
        let hashOne = substringData.sha256
        let hashTwo = hashOne.sha256
        _ = [UInt8](hashTwo)
        let finalKeyData = Data(bytes: shortened[1...shortened.count - 1])
        return finalKeyData
    }
    
    func dataWithHexString() -> Data {
        var hex = self
        var data = Data()
        while hex.count > 0 {
            let c: String = String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    func hexString() -> String {
        return self.data(using: .utf8)?.hexString ?? ""
    }
}
