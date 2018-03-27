//
//  NEP2.swift
//  NeoSwift
//
//  Created by Luís Silva on 11/10/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neoutils

class NEP2 {
    public static func decryptKey(_ key: String, passphrase: String) -> (key: [UInt8], hash: [UInt8])? {
        guard let encryptedKeyBytes = key.base58CheckDecodedBytes else { return nil }
        
        let addressHash = [UInt8](encryptedKeyBytes[3..<7])
        let encryptedHalf1 = [UInt8](encryptedKeyBytes[7..<23])
        let encryptedHalf2 = [UInt8](encryptedKeyBytes[23..<39])
        
        let derived = scrypt().scrypt(passphrase: [UInt8](passphrase.utf8), salt: addressHash, n: 16384, r: 8, p: 8, dkLen: 64)
        let derivedHalf1 = [UInt8](derived[0..<32])
        let derivedHalf2 = [UInt8](derived[32..<64])
        
        let decryptedHalf1 = AES.decrypt(bytes: encryptedHalf1, key: derivedHalf2, keySize: AES.KeySize.keySize256, pkcs7Padding: false).xor(other: [UInt8](derivedHalf1[0..<16]))
        let decryptedHalf2 = AES.decrypt(bytes: encryptedHalf2, key: derivedHalf2, keySize: AES.KeySize.keySize256, pkcs7Padding: false).xor(other: [UInt8](derivedHalf1[16..<32]))
        
        let decryptedKey = decryptedHalf1 + decryptedHalf2
        
        return (key: decryptedKey, hash: addressHash)
    }
    
    public static func verify(addressHash: [UInt8], address: String) -> Bool {
        let addressHashSource = [UInt8](address.utf8)
        let calculatedHash = [UInt8](addressHashSource.sha256.sha256[0..<4])
        
        return calculatedHash == addressHash
    }
    
    public static func encryptKey(_ key: [UInt8], passphrase: String, address: String) -> String {
        let addressHashSource = [UInt8](address.utf8)
        let addressHash = [UInt8](addressHashSource.sha256.sha256[0..<4])
        
        let derived = scrypt().scrypt(passphrase: [UInt8](passphrase.utf8), salt: addressHash, n: 16384, r: 8, p: 8, dkLen: 64)
        
        let derivedHalf1 = [UInt8](derived[0..<32])
        let derivedHalf2 = [UInt8](derived[32..<64])
        
        let block1 = [UInt8](key[0..<16]).xor(other: [UInt8](derivedHalf1[0..<16]))
        let block2 = [UInt8](key[16..<32]).xor(other: [UInt8](derivedHalf1[16..<32]))
        
        let encryptedHalf1 = AES.encrypt(bytes: block1, key: derivedHalf2, keySize: AES.KeySize.keySize256, pkcs7Padding: false)
        let encryptedHalf2 = AES.encrypt(bytes: block2, key: derivedHalf2, keySize: AES.KeySize.keySize256, pkcs7Padding: false)
        
        let toEncode: [UInt8] = [0x01, 0x42, 0xE0] + addressHash + encryptedHalf1 + encryptedHalf2
        
        return toEncode.base58CheckEncodedString
    }
}
