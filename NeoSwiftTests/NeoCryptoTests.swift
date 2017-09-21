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
        XCTAssert( String(data: "GRvKwF9B69ssT67JgRWxPQTZ2X".base58DecodedData!, encoding: .utf8) == "THE QUICK BROWN FOX")
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
}
