//
//  TransactionHistory.swift
//  O3
//
//  Created by Apisit Toompakdee on 8/20/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class TransactionHistory: NSObject, Codable {
    @objc let list: [TransactionHistoryItem]
    @objc let totalPage: Int
    @objc let pageIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case list = "history"
        case totalPage = "totalPage"
        case pageIndex = "pageIndex"
    }
}

@objc public class TransactionHistoryItem: NSObject, Codable {
    @objc let blockchain: String
    @objc let txid: String
    @objc let time: Int
    @objc let blockHeight: Int
    @objc let asset: Asset
    @objc let amount: String
    @objc let to: String
    @objc let from: String
    
    enum CodingKeys: String, CodingKey {
        case blockchain = "blockchain"
        case txid = "txid"
        case time = "time"
        case blockHeight = "blockHeight"
        case asset = "asset"
        case amount = "amount"
        case to = "to"
        case from = "from"
    }
}

enum Blockchain: String, Codable {
    case neo = "neo"
    case ontology = "ontology"
}
