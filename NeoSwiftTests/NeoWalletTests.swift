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
        guard let a = Account(),
            let b = Account(wif: a.wif) else {
                assert(false)
                return
        }
        assert(a.privateKey == b.privateKey)
    }
    
    func testCreateAccountWif() {
        guard let a = Account(wif: "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm") else {
            assert(false)
            return
        }
        assert(a.address == "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a.privateKeyString == "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
    }
    
    func testCreateAccountWrongWif() {
        guard Account(wif: "L33xET8EkayBJzwSZ9vRi4") != nil else {
            assert(true)
            return
        }
        assert(false)
    }
    
    func testCreateAccountPrivateKey() {
        guard let a = Account(privateKey: "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7") else {
            assert(false)
            return
        }
        assert(a.address == "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a.wif == "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
    }
    
    func testCreateAccountWrongPrivateKey() {
        guard Account(privateKey: "ae012da38dfba592d28859cbad4cf6276e") != nil else {
            assert(true)
            return
        }
        assert(false)
    }
    
    func testCreateAccountEncrpytedAndPassphrase() {
        guard let a = Account(encryptedPrivateKey: "6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB", passphrase: "neoswifttest") else {
            assert(false)
            return
        }
        assert(a.address == "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a.wif == "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
        assert(a.privateKeyString == "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
    }
    
    func testCreateAccountWrongEncrpytedAndPassphrase() {
        guard Account(encryptedPrivateKey: "KwxrTNGVC62dZ76PeCMnSPgxJdWVNktdvP9scjdvhwLPB9Nr6yDB", passphrase: "neoswifttest") != nil else {
            assert(true)
            return
        }
        assert(false)
    }
    
    func testCreateAccountEncrpytedAndWrongPassphrase() {
        guard let a = Account(encryptedPrivateKey: "6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB", passphrase: "neoswifttestasdf") else {
            assert(true)
            return
        }
        assert(a.address != "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a.wif != "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
        assert(a.privateKeyString != "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
    }
}
