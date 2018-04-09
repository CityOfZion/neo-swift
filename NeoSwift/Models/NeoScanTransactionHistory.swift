//
//  NeoScanTransactionHistory.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 4/9/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

public struct NEOScanTransactionHistory: Codable {
    public var total_pages: Int
    public var total_entries: Int
    public var page_size: Int
    public var page_number: Int
    public var entries: [NeoScanTransactionEntry]
    
    enum CodingKeys: String, CodingKey {
        case total_pages = "total_pages"
        case total_entries = "total_entries"
        case page_size = "page_size"
        case page_number = "page_number"
        case entries = "entries"
    }
    
    public init(total_pages: Int, total_entries: Int, page_size: Int,
                page_number: Int, entries: [NeoScanTransactionEntry]) {
        self.total_pages = total_pages
        self.total_entries = total_entries
        self.page_size = page_size
        self.page_number = page_number
        self.entries = entries
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let total_pages: Int = try container.decode(Int.self, forKey: .total_pages)
        let total_entries: Int = try container.decode(Int.self, forKey: .total_entries)
        let page_size: Int = try container.decode(Int.self, forKey: .page_size)
        let page_number: Int = try container.decode(Int.self, forKey: .page_number)
        let entries: [NeoScanTransactionEntry] = try container.decode([NeoScanTransactionEntry].self, forKey: .entries)
        self.init(total_pages: total_pages, total_entries: total_entries, page_size: page_size,
                  page_number: page_number, entries: entries)
    }
    
}

public struct NeoScanTransactionEntry: Codable {
    public var txid: String
    public var time: Int
    public var id: Int
    public var block_height: Int
    public var asset: String
    public var amount: Double
    public var address_to: String
    public var address_from: String
    
    
    enum CodingKeys : String, CodingKey {
        case txid = "txid"
        case time = "time"
        case id = "id"
        case block_height = "block_height"
        case asset = "asset"
        case amount = "amount"
        case address_to = "address_to"
        case address_from = "address_from"
    }
    
    public init(txid: String, time: Int, id: Int, block_height: Int, asset: String,
                amount: Double, address_to: String, address_from: String) {
        self.txid = txid
        self.time = time
        self.id = id
        self.block_height = block_height
        self.asset = asset
        self.amount = amount
        self.address_to = address_to
        self.address_from = address_from
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let txid: String = try container.decode(String.self, forKey: .txid)
        let time: Int = try container.decode(Int.self, forKey: .time)
        let id: Int = try container.decode(Int.self, forKey: .id)
        let block_height: Int = try container.decode(Int.self, forKey: .block_height)
        let asset: String = try container.decode(String.self, forKey: .asset)
        let amountString: String = try container.decode(String.self, forKey: .amount)
        let amount = Double(amountString)!
        let address_to: String = try container.decode(String.self, forKey: .address_to)
        let address_from: String = try container.decode(String.self, forKey: .address_from)
        self.init(txid: txid, time: time, id: id, block_height: block_height, asset: asset,
                  amount: amount, address_to: address_to, address_from: address_from)
    }
}

