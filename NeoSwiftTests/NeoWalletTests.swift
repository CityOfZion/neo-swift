//
//  NeoWalletTests.swift
//  NeoSwiftTests
//
//  Created by Andrei Terentiev on 9/6/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest
import NeoSwift

class NeoWalletTests: XCTestCase {
    
    func testImportWifAndSamePrivateKey() {
        let a = Account()
        guard let b = Account(wif: a.wif) else {
            assert(false)
            return
        }
        assert(a.privateKey == b.privateKey)
    }
    
    func testCreateAccountWif() {
        let a = Account(wif: "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
        assert(a?.address == "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a?.privateKeyString == "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
    }
    
    func testCreateAccountWrongWif() {
        guard Account(wif: "L33xET8EkayBJzwSZ9vRi4") != nil else {
            assert(true)
            return
        }
    }
    
    func testCreateAccountPrivateKey() {
        let a = Account(privateKey: "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
        assert(a?.address == "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a?.wif == "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
    }
    
    func testCreateAccountWrongPrivateKey() {
        guard Account(privateKey: "ae012da38dfba592d28859cbad4cf6276e") != nil else {
            assert(true)
            return
        }
    }
    
    func testCreateAccountEncrpytedAndPassphrase() {
        let a = Account(encryptedPrivateKey: "6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB", passphrase: "neoswifttest")
        assert(a?.address == "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a?.wif == "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
        assert(a?.privateKeyString == "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
    }
    
    func testCreateAccountWrongEncrpytedAndPassphrase() {
        guard Account(encryptedPrivateKey: "KwxrTNGVC62dZ76PeCMnSPgxJdWVNktdvP9scjdvhwLPB9Nr6yDB", passphrase: "neoswifttest") != nil else {
            assert(true)
            return
        }
    }
    
    func testCreateAccountEncrpytedAndWrongPassphrase() {
        guard Account(encryptedPrivateKey: "6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB", passphrase: "neoswifttestasdf") != nil else {
            assert(true)
            return
        }
    }
}
