//
//  scrypt.swift
//  NeoSwift
//
//  Created by Luís Silva on 22/09/17.
//  Copyright © 2017 drei. All rights reserved.
//
//  https://tools.ietf.org/html/rfc7914

import Foundation

var salsaCount = 0
var blockMixCount = 0
var roMixCount = 0

@objc public class Scrypt: NSObject, Codable {
    @objc public let n: Int = 16384
    @objc public let r: Int = 8
    @objc public let p: Int = 8
    @objc public let dkLen: Int = 64
    
    private enum CodingKeys: String, CodingKey {
        case n
        case r
        case p
        case dkLen
    }
    
    final private var salsaBuffer: [UInt32] = [UInt32](repeating: 0, count: 16)
    final private var salsaOutput: [UInt32] = [UInt32](repeating: 0, count: 16)
    
    @objc public func scrypt(passphrase: [UInt8], salt: [UInt8]) -> [UInt8] {
        var B = PBKDF2.deriveKey(password: passphrase, salt: salt, rounds: 1, keyLength: self.p * 128 * self.r)
        
        var result: [UInt8] = []
        for i in 0...self.p-1 {
            let blockStart = i * (128 * self.r)
            let blockEnd = (i + 1) * (128 * self.r)
            let block = Array(B[blockStart..<blockEnd])
            let blockMix = scryptROMix(block, r: self.r, N: self.n)
            result.append(contentsOf: blockMix)
        }
        
        return PBKDF2.deriveKey(password: passphrase, salt: result, rounds: 1, keyLength: self.dkLen)
    }
    
    final func R(_ a: UInt32, _ b: UInt32) -> UInt32 {
        return (a << b) | (a >> (32 - b))
    }
    
    // Salsa20/8 Core
    final func salsa(_ input: [UInt32], output: inout [UInt32]) {
        assert(input.count == 16)
        
        salsaBuffer = input
        
        var i = 8
        while 0 < i {
            salsaBuffer[ 4] ^= R(salsaBuffer[ 0]&+salsaBuffer[12], 7);  salsaBuffer[ 8] ^= R(salsaBuffer[ 4]&+salsaBuffer[ 0], 9);
            salsaBuffer[12] ^= R(salsaBuffer[ 8]&+salsaBuffer[ 4],13);  salsaBuffer[ 0] ^= R(salsaBuffer[12]&+salsaBuffer[ 8],18);
            salsaBuffer[ 9] ^= R(salsaBuffer[ 5]&+salsaBuffer[ 1], 7);  salsaBuffer[13] ^= R(salsaBuffer[ 9]&+salsaBuffer[ 5], 9);
            salsaBuffer[ 1] ^= R(salsaBuffer[13]&+salsaBuffer[ 9],13);  salsaBuffer[ 5] ^= R(salsaBuffer[ 1]&+salsaBuffer[13],18);
            salsaBuffer[14] ^= R(salsaBuffer[10]&+salsaBuffer[ 6], 7);  salsaBuffer[ 2] ^= R(salsaBuffer[14]&+salsaBuffer[10], 9);
            salsaBuffer[ 6] ^= R(salsaBuffer[ 2]&+salsaBuffer[14],13);  salsaBuffer[10] ^= R(salsaBuffer[ 6]&+salsaBuffer[ 2],18);
            salsaBuffer[ 3] ^= R(salsaBuffer[15]&+salsaBuffer[11], 7);  salsaBuffer[ 7] ^= R(salsaBuffer[ 3]&+salsaBuffer[15], 9);
            salsaBuffer[11] ^= R(salsaBuffer[ 7]&+salsaBuffer[ 3],13);  salsaBuffer[15] ^= R(salsaBuffer[11]&+salsaBuffer[ 7],18);
            salsaBuffer[ 1] ^= R(salsaBuffer[ 0]&+salsaBuffer[ 3], 7);  salsaBuffer[ 2] ^= R(salsaBuffer[ 1]&+salsaBuffer[ 0], 9);
            salsaBuffer[ 3] ^= R(salsaBuffer[ 2]&+salsaBuffer[ 1],13);  salsaBuffer[ 0] ^= R(salsaBuffer[ 3]&+salsaBuffer[ 2],18);
            salsaBuffer[ 6] ^= R(salsaBuffer[ 5]&+salsaBuffer[ 4], 7);  salsaBuffer[ 7] ^= R(salsaBuffer[ 6]&+salsaBuffer[ 5], 9);
            salsaBuffer[ 4] ^= R(salsaBuffer[ 7]&+salsaBuffer[ 6],13);  salsaBuffer[ 5] ^= R(salsaBuffer[ 4]&+salsaBuffer[ 7],18);
            salsaBuffer[11] ^= R(salsaBuffer[10]&+salsaBuffer[ 9], 7);  salsaBuffer[ 8] ^= R(salsaBuffer[11]&+salsaBuffer[10], 9);
            salsaBuffer[ 9] ^= R(salsaBuffer[ 8]&+salsaBuffer[11],13);  salsaBuffer[10] ^= R(salsaBuffer[ 9]&+salsaBuffer[ 8],18);
            salsaBuffer[12] ^= R(salsaBuffer[15]&+salsaBuffer[14], 7);  salsaBuffer[13] ^= R(salsaBuffer[12]&+salsaBuffer[15], 9);
            salsaBuffer[14] ^= R(salsaBuffer[13]&+salsaBuffer[12],13);  salsaBuffer[15] ^= R(salsaBuffer[14]&+salsaBuffer[13],18);
            
            i -= 2
        }
        
        i = 0
        for i in 0..<16 {
            output[i] = salsaBuffer[i] &+ input[i]
        }
        
    }
    
    final func scryptBlockMix(_ B: [UInt32], r: Int) -> [UInt32] {
        var B = B
        var B_: [UInt32] = Array<UInt32>(repeating: 0, count: B.count)
        
        let ptrB = UnsafeRawPointer(B).advanced(by: (2 * r - 1) * 64)
        let ptrX = UnsafeMutableRawPointer(mutating: salsaOutput)
        memcpy(ptrX, ptrB, 64)
        
        for i in 0..<(2 * r) {
            for j in 0..<16 {
                salsaOutput[j] ^= B[16 * i + j]
            }
            
            salsa(salsaOutput, output: &(salsaOutput))
            
            memcpy(&B_[(i / 2 + (i & 1) * r) * 16], UnsafeRawPointer(salsaOutput), salsaOutput.count * 4)
        }
        
        return B_
    }
    
    final func scryptROMix(_ B: [UInt8], r: Int, N: Int) -> [UInt8] {
        var X = B
        var V: [[UInt8]] = []
        
        for _ in 0..<N {
            V.append(X)
            X = scryptBlockMix(X.toWordArray(), r: r).toByteArray()
        }
        
        for _ in 0..<N {
            let j_ = integerify(X, r: r)
            let j = Int(j_ % UInt(N))
            
            var T = Array<UInt8>(repeating: 0, count: X.count)
            for k in 0..<X.count {
                T[k] = X[k] ^ V[j][k]
            }
            X = scryptBlockMix(T.toWordArray(), r: r).toByteArray()
        }
        return X
    }
    
    func integerify(_ X: [UInt8], r: Int) -> UInt {
        let x = [UInt8](X[((2 * r - 1) * 64)...])
        
        var i = UInt(x[0]) + UInt(x[1]) << 8
        i += UInt(x[2]) << 16 + UInt(x[3]) << 24
        i += UInt(x[4]) << 32 + UInt(x[5]) << 40
        i += UInt(x[6]) << 48 + UInt(x[7]) << 56
        
        return i
    }
}
