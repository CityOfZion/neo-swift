//
//  Balance.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

typealias UTXO = Assets.UTXO

@objc public class Assets: NSObject, Codable {
    @objc public var data: [UTXO]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    public init(data: [UTXO]) {
        self.data = data
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data: [UTXO] = try container.decode([UTXO].self, forKey: .data)
        self.init(data: data)
    }
    
    @objc public func getSortedGASUTXOs() -> [UTXO] {
        let filteredGASUTXOs = data.filter { (utxo) -> Bool in
            return utxo.asset.contains(AssetId.gasAssetId.rawValue)
        }
        return filteredGASUTXOs.sorted {$0.value < $1.value }
        
    }
    
    @objc public func getSortedNEOUTXOs() -> [UTXO] {
        let filteredNEOUTXOs = data.filter { (utxo) -> Bool in
            return utxo.asset.contains(AssetId.neoAssetId.rawValue)
        }
        return filteredNEOUTXOs.sorted {$0.value < $1.value }
    }
    
    @objc public class UTXO: NSObject, Codable {
        @objc public var asset: String
        @objc public var index: Int
        @objc public var txid: String
        @objc public var value: Decimal
        @objc public var createdAtBlock: Int
        
        enum CodingKeys: String, CodingKey {
            case asset
            case index
            case txid
            case value
            case createdAtBlock
        }
        
        public init(asset: String, index: Int, txid: String, value: Decimal, createdAtBlock: Int) {
            self.asset = asset
            self.index = index
            self.txid = txid
            self.value = value
            self.createdAtBlock = createdAtBlock
        }
        
        public required convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let asset: String = try container.decode(String.self, forKey: .asset)
            let index: Int = try container.decode(Int.self, forKey: .index)
            var txid: String = try container.decode(String.self, forKey: .txid)
            if txid.hasPrefix("0x") {
                txid = String(txid.dropFirst(2))
            }
            let createdAtBlock: Int = try container.decode(Int.self, forKey: .createdAtBlock)
            let valueString: String = try container.decode(String.self, forKey: .value)
            let format = NumberFormatter()
            format.locale = Locale(identifier: "en_US")
            format.minimumFractionDigits = 0
            format.maximumFractionDigits = 8
            let value = format.number(from: valueString)?.decimalValue
            self.init(asset: asset, index: index, txid: txid, value: value!, createdAtBlock: createdAtBlock)
        }
    }
}
