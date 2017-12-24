//
//  NEOECDH.swift
//  NeoSwiftTests
//
//  Created by Apisit Toompakdee on 12/24/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest

class NEOECDH: XCTestCase {
 
    var alice:Account! //new alice wallet
    var bob:Account! //new bob wallet
    var m:Account! //new random actor wallet
    let message = "Hello bob. it's alice"
    override func setUp() {
        super.setUp()
        alice = Account()
        bob = Account()
        m = Account()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGenerateShareSecret() {
        print("Alice's NEO Address", alice.address)
        print("Bob's NEO Address:", bob.address)
        let aliceSharedSecret = alice?.createSharedSecret(publicKey: bob!.publicKey)
        let bobSharedSecret = bob?.createSharedSecret(publicKey: alice!.publicKey)
        //using public key encryption
        //Alice and Bob shared secret should be identical
        XCTAssert(aliceSharedSecret?.fullHexString == bobSharedSecret?.fullHexString)
    }
    
    func testEncryptionUsingShareSecret() {
        let aliceAndBobSharedSecret = alice?.createSharedSecret(publicKey: bob!.publicKey)
        let bobAndAliceSharedSecret = bob?.createSharedSecret(publicKey: alice!.publicKey)

        let encryptedMessage = alice?.encryptString(key: aliceAndBobSharedSecret!, text: message)
        print("encrypted message:", encryptedMessage!)
        let descryptedMessage = bob?.decryptString(key: bobAndAliceSharedSecret!, text: encryptedMessage!)
        print("decrypted message:", descryptedMessage!)
        XCTAssert(descryptedMessage == message)
    }
    
    func testTryToUseAnotherSharedSecretToDecryptMessage() {
        let aliceAndBobSharedSecret = alice?.createSharedSecret(publicKey: bob!.publicKey)
        let mAndAliceSharedSecret = m?.createSharedSecret(publicKey: alice!.publicKey)
        
        //Alice is sending bob a message using a shared secret generate from Bob's public key and Alice's private key
        let encryptedMessage = alice?.encryptString(key: aliceAndBobSharedSecret!, text: message)
        print("encrypted message:", encryptedMessage!)
        
        //M is trying to descrypt a message using a share secret between M and Alice
        let descryptedMessage = m?.decryptString(key: mAndAliceSharedSecret!, text: encryptedMessage!)
        print("decrypted message:", descryptedMessage ?? "")
        //M should not be able to read a mesage Alice sent to Bob
        XCTAssert(descryptedMessage != message)
        
    }
}
