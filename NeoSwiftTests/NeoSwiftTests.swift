//
//  NeoSwiftTests.swift
//  NeoSwiftTests
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import XCTest
import NeoSwift

class NeoSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetBlockCount() {
        let exp = expectation(description: "Wait for block count response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        neo.getBlockCount() { count, error in
            assert(count != nil)
            print(count!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBestBlockHash() {
        let exp = expectation(description: "Wait for block hash response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        neo.getBestBlockHash() { hash, error in
            assert(hash != nil)
            print(hash!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
     func testGetBlockByHash() {
        let exp = expectation(description: "Wait for block hash response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        neo.getBlockBy(hash: "f7bcd551a40398ce51e65317fc4d2b48bde3743d563af16c2ca145d08b074461") { block, error in
            assert(block != nil)
            print(block!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBlockByIndex() {
        let exp = expectation(description: "Wait for block hash response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        neo.getBlockBy(index: 42) { block, error in
            assert(block != nil)
            print(block!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetBlockHashByIndex() {
        let exp = expectation(description: "Wait for block hash response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
    
        neo.getBlockHash(for: 42) { hash, error in
            assert(hash != nil)
            print(hash!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testConnectionCount() {
        let exp = expectation(description: "Wait for block count response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        neo.getConnectionCount() { count, error in
            assert(count != nil)
            print(count!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetMemPool() {
        let exp = expectation(description: "Wait for block hash response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        neo.getUnconfirmedTransactions() { transactions, error in
            assert(transactions != nil)
            print(transactions!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testTransactionForHash() {
        let exp = expectation(description: "Wait for block hash response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        let hash = "2288ba9bd93da4ac4c414048f019300c8adadc6df5e4bfeb6fc79da7f955e638"
        neo.getTransaction(for: hash) { transaction, error in
            assert(transaction != nil)
            print(transaction!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testTransactionOutput() {
        let exp = expectation(description: "Wait for block hash response")
        let neo = NeoClient(seed: "http://seed4.neo.org:10332")
        
        let hash = "2288ba9bd93da4ac4c414048f019300c8adadc6df5e4bfeb6fc79da7f955e638"
        let index: Int64 = 0
        neo.getTransactionOutput(with: hash, and: index) { valueOut, error in
            assert(valueOut != nil)
            print(valueOut!)
            exp.fulfill()
            return
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
