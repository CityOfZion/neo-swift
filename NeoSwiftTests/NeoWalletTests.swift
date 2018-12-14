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
        let b = Account(wif: a.wif)
        assert(a.privateKey == b?.privateKey)
    }
    
    func testExportKeystoreJsonWithoutKey() {
        let a = Account()
        a.exportKeystoreJson { (json, error) in
            assert(json == nil)
            assert(error != nil)
        }
    }
    
    func testExportKeystoreJsonWithKey() {
        let a = Account(encryptedPrivateKey: "6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB", passphrase: "neoswifttest")
        a?.exportKeystoreJson(completion: { (json, error) in
            assert(json != nil)
            assert(error == nil)
        })
    }
    
    func testImportKeystoreJsonWrongFormat() {
        let json = "{\"name\":null,\"scrypt\":{1.0\"}"
        
        let wallet = Wallet.importKeystoreJson(json, passphrase: "neoswifttest")
        assert(wallet == nil)
    }
    
    func testImportKeystoreJson() {
        let json = "{\"name\":null,\"scrypt\":{\"r\":8,\"p\":8,\"n\":16384,\"dkLen\":64},\"accounts\":[{\"address\":\"ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu\",\"label\":null,\"key\":\"6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB\",\"lock\":false,\"extra\":null,\"isDefault\":false}],\"extra\":null,\"version\":\"1.0\"}"
        
        let wallet = Wallet.importKeystoreJson(json, passphrase: "neoswifttest")
        let a = wallet?.accounts.first
        assert(a?.wif == "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
        assert(a?.privateKeyString == "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
    }
    
    func testImportKeystoreJsonWrongPaspharase() {
        let json = "{\"name\":null,\"scrypt\":{\"r\":8,\"p\":8,\"n\":16384,\"dkLen\":64},\"accounts\":[{\"address\":\"ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu\",\"label\":null,\"key\":\"6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB\",\"lock\":false,\"extra\":null,\"isDefault\":false}],\"extra\":null,\"version\":\"1.0\"}"
        
        let wallet = Wallet.importKeystoreJson(json, passphrase: "abcabc")
        let a = wallet?.accounts.first
        assert(a?.wif == "")
        assert(a?.privateKeyString == "")
    }
    
    func testCreateAccountWif() {
        let a = Account(wif: "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
        assert(a?.address == "ANC6ANC9tjEVEJg29JsNp3ixNMgbUzVYwu")
        assert(a?.publicKeyString == "030eff1340988ee79420e42864cb91dcc6e3ed8314a46bae94f6d92185091ca55a")
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
