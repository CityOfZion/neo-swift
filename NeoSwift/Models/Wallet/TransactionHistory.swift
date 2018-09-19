//
//  TransactionHistory.swift
//  O3
//
//  Created by Apisit Toompakdee on 8/20/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

struct TransactionHistory: Codable {
    let list: [TransactionHistoryItem]
    let totalPage: Int
    let pageIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case list = "history"
        case totalPage = "totalPage"
        case pageIndex = "pageIndex"
    }
}

struct TransactionHistoryItem: Codable {
    let blockchain: String
    let txid: String
    let time: Int
    let blockHeight: Int
    let asset: Asset
    let amount: String
    let to: String
    let from: String
    
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
