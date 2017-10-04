//
//  scrypt.swift
//  NeoSwift
//
//  Created by Luís Silva on 22/09/17.
//  Copyright © 2017 drei. All rights reserved.
//
//  https://tools.ietf.org/html/rfc7914

import Foundation

struct scrypt {
    
    internal static func R(_ a: UInt32, _ b: UInt32) -> UInt32 {
        return (a << b) | (a >> (32 - b))
    }
    
    // Salsa20/8 Core
    static func salsa(_ input: [UInt32]) -> [UInt32] {
        assert(input.count == 16)
        
        var x = input
        var output: [UInt32] = Array<UInt32>(repeating: 0, count: 16)
        
        var i = 8
        while 0 < i {
            x[ 4] ^= R(x[ 0]&+x[12], 7);  x[ 8] ^= R(x[ 4]&+x[ 0], 9);
            x[12] ^= R(x[ 8]&+x[ 4],13);  x[ 0] ^= R(x[12]&+x[ 8],18);
            x[ 9] ^= R(x[ 5]&+x[ 1], 7);  x[13] ^= R(x[ 9]&+x[ 5], 9);
            x[ 1] ^= R(x[13]&+x[ 9],13);  x[ 5] ^= R(x[ 1]&+x[13],18);
            x[14] ^= R(x[10]&+x[ 6], 7);  x[ 2] ^= R(x[14]&+x[10], 9);
            x[ 6] ^= R(x[ 2]&+x[14],13);  x[10] ^= R(x[ 6]&+x[ 2],18);
            x[ 3] ^= R(x[15]&+x[11], 7);  x[ 7] ^= R(x[ 3]&+x[15], 9);
            x[11] ^= R(x[ 7]&+x[ 3],13);  x[15] ^= R(x[11]&+x[ 7],18);
            x[ 1] ^= R(x[ 0]&+x[ 3], 7);  x[ 2] ^= R(x[ 1]&+x[ 0], 9);
            x[ 3] ^= R(x[ 2]&+x[ 1],13);  x[ 0] ^= R(x[ 3]&+x[ 2],18);
            x[ 6] ^= R(x[ 5]&+x[ 4], 7);  x[ 7] ^= R(x[ 6]&+x[ 5], 9);
            x[ 4] ^= R(x[ 7]&+x[ 6],13);  x[ 5] ^= R(x[ 4]&+x[ 7],18);
            x[11] ^= R(x[10]&+x[ 9], 7);  x[ 8] ^= R(x[11]&+x[10], 9);
            x[ 9] ^= R(x[ 8]&+x[11],13);  x[10] ^= R(x[ 9]&+x[ 8],18);
            x[12] ^= R(x[15]&+x[14], 7);  x[13] ^= R(x[12]&+x[15], 9);
            x[14] ^= R(x[13]&+x[12],13);  x[15] ^= R(x[14]&+x[13],18);
            
            i -= 2
        }
        
        i = 0
        for i in 0..<16 {
            output[i] = x[i] &+ input[i]
        }
        
        return output
    }
    
    static func scryptBlockMix(_ B: [UInt32], r: Int) -> [UInt32] {
        var B = B
        var X: [UInt32] = Array<UInt32>(repeating: 0, count: 16)
        var B_: [UInt32] = Array<UInt32>(repeating: 0, count: B.count)
        
        let ptrB = UnsafeRawPointer(B).advanced(by: (2 * r - 1) * 64)
        let ptrX = UnsafeMutableRawPointer(mutating: X)
        memcpy(ptrX, ptrB, 64)
        
        for i in 0..<(2 * r) {
            for j in 0..<16 {
                X[j] ^= B[16 * i + j]
            }
            X = salsa(X)
            memcpy(&B_[(i / 2 + (i & 1) * r) * 16], X.toByteArray(), X.count * 4)
        }
        
        return B_
    }
    
    static func scryptROMix(_ B: [UInt8], r: Int, N: Int) -> [UInt8] {
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
    
    static func integerify(_ X: [UInt8], r: Int) -> UInt {
        let x = [UInt8](X[((2 * r - 1) * 64)...])
        
        var i = UInt(x[0]) + UInt(x[1]) << 8
        i += UInt(x[2]) << 16 + UInt(x[3]) << 24
        i += UInt(x[4]) << 32 + UInt(x[5]) << 40
        i += UInt(x[6]) << 48 + UInt(x[7]) << 56
        
        return i
    }
    
    static func scrypt(passphrase: [UInt8], salt: [UInt8], n: Int, r: Int, p: Int, dkLen: Int) -> [UInt8] {
        var B = PBKDF2.deriveKey(password: passphrase, salt: salt, rounds: 1, keyLength: p * 128 * r)
        
        var result: [UInt8] = []
        for i in 0...p-1 {
            let blockStart = i * (128 * r)
            let blockEnd = (i + 1) * (128 * r)
            let block = Array(B[blockStart..<blockEnd])
            let blockMix = scryptROMix(block, r: r, N: n)
            result.append(contentsOf: blockMix)
        }
        
        return PBKDF2.deriveKey(password: passphrase, salt: result, rounds: 1, keyLength: dkLen)
    }
}







































