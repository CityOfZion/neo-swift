//
//  NeoCryptoTests.swift
//  NeoSwiftTests
//
//  Created by Luís Silva on 16/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest

class NeoCryptoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Base58
    
    func testBase58Encoding() {
        
        
        XCTAssert("derp".base58EncodedString == "3ZqqXd")
        XCTAssert("1".base58EncodedString == "r")
        XCTAssert("the quick brown fox".base58EncodedString == "NK2qR8Vz63NeeAJp9XRifbwahu")
        XCTAssert("THE QUICK BROWN FOX".base58EncodedString == "GRvKwF9B69ssT67JgRWxPQTZ2X")
        
    }
    
    func testBase58Decoding() {
        
        
        XCTAssert(String(data: "3ZqqXd".base58DecodedData!, encoding: .utf8) == "derp")
        XCTAssert(String(data: "r".base58DecodedData!, encoding: .utf8) == "1")
        XCTAssert(String(data: "NK2qR8Vz63NeeAJp9XRifbwahu".base58DecodedData!, encoding: .utf8) == "the quick brown fox")
        XCTAssert(String(data: "GRvKwF9B69ssT67JgRWxPQTZ2X".base58DecodedData!, encoding: .utf8) == "THE QUICK BROWN FOX")
    }
    
    // MARK: Base58Check
    
    func testBase58CheckEncoding() {
        let d1 = "00010966776006953D5567439E5E39F86A0D273BEE".dataWithHexString().bytes
        XCTAssert(d1.base58CheckEncodedString == "16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM")

        let d2 = "005C092BF62192E10F71E96A8B7E39C437BABEB8C9".dataWithHexString().bytes
        XCTAssert(d2.base58CheckEncodedString == "19Pe9uqYgFYTVZMZYvXTTecitzyVDfxr9m")
    }
    
    func testBase58CheckDecoding() {
        XCTAssert("19Pe9uqYgFYTVZMZYvXTTecitzyVDfxr9m".base58CheckDecodedData == "005C092BF62192E10F71E96A8B7E39C437BABEB8C9".dataWithHexString())
    }
    
    // MARK: - SHA256
    
    func testSHA256() {
        XCTAssert("".sha256?.fullHexString == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
        XCTAssert("NEO".sha256?.fullHexString == "1a259dba256600620c6c91094f3a300b30f0cbaecee19c6114deffd3288957d7")
        XCTAssert("Smart Economy".sha256?.fullHexString == "6c4cb281896c7779f4e2800471638026d52178b2556a0a3fbc3673368ba97385")
    }
    
    // MARK: - AES
    
    func testAES256() {
        // key, plain, cipher
        let tests = [
            ["603DEB1015CA71BE2B73AEF0857D77811F352C073B6108D72D9810A30914DFF4", "6BC1BEE22E409F96E93D7E117393172A", "F3EED1BDB5D2A03C064B5A7E3DB181F8"],
            ["603DEB1015CA71BE2B73AEF0857D77811F352C073B6108D72D9810A30914DFF4", "AE2D8A571E03AC9C9EB76FAC45AF8E51", "591CCB10D410ED26DC5BA74A31362870"],
            ["603DEB1015CA71BE2B73AEF0857D77811F352C073B6108D72D9810A30914DFF4", "30C81C46A35CE411E5FBC1191A0A52EF", "B6ED21B99CA6F4F9F153E7B1BEAFED1D"]
        ]
        
        for test in tests {
            let key = test[0].dataWithHexString().bytes
            let plain = test[1].dataWithHexString().bytes
            let cipher = test[2].dataWithHexString().bytes

            let r1 = AES.encrypt(bytes: plain, key: key, keySize: .keySize256, pkcs7Padding: false)
            XCTAssert(r1 == cipher)
            
            let r2 = AES.decrypt(bytes: cipher, key: key, keySize: .keySize256, pkcs7Padding: false)
            XCTAssert(r2 == plain)
        }
    }
}

