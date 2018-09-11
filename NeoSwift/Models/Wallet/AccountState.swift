//
//  AccountState.swift
//  O3
//
//  Created by Andrei Terentiev on 5/7/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

typealias TransferableAsset = AccountState.TransferableAsset

public struct AccountState: Codable {
    var version: Int
    var address: String
    var scriptHash: String
    var assets: [TransferableAsset]
    var nep5Tokens: [TransferableAsset]
    var ontology: [TransferableAsset]
    
    enum CodingKeys: String, CodingKey {
        case version
        case address
        case scriptHash
        case assets
        case nep5Tokens
        case ontology
    }
    
    public init(version: Int, address: String, scriptHash: String,
                assets: [TransferableAsset], nep5Tokens: [TransferableAsset], ontology: [TransferableAsset]?) {
        self.version = version
        self.address = address
        self.scriptHash = scriptHash
        self.assets = assets
        self.nep5Tokens = nep5Tokens
        if ontology != nil {
            self.ontology = ontology!
        } else {
            self.ontology = []
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let version: Int = try container.decode(Int.self, forKey: .version)
        let address: String = try container.decode(String.self, forKey: .address)
        let scriptHash: String = try container.decode(String.self, forKey: .scriptHash)
        let assets: [TransferableAsset] = try container.decode([TransferableAsset].self, forKey: .assets)
        let nep5Tokens: [TransferableAsset] = try container.decode([TransferableAsset].self, forKey: .nep5Tokens)
        let ontology: [TransferableAsset]? = try? container.decode([TransferableAsset].self, forKey: .ontology)
        self.init(version: version, address: address, scriptHash: scriptHash, assets: assets, nep5Tokens: nep5Tokens, ontology: ontology)
    }
    
    public struct TransferableAsset: Codable {
        var id: String
        var name: String
        var symbol: String
        var decimals: Int
        var value: Double
        var assetType: AssetType
        
        public enum AssetType: String, Codable {
            case neoAsset
            case nep5Token
            case ontologyAsset
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case symbol
            case decimals
            case value
        }
        
        public init(id: String, name: String, symbol: String, decimals: Int, value: Double, assetType: AssetType) {
            self.id = id
            self.name = name
            self.symbol = symbol
            self.decimals = decimals
            self.value = value
            self.assetType = assetType
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let id = try container.decode(String.self, forKey: .id)
            let name = try container.decode(String.self, forKey: .name)
            let symbol = try container.decode(String.self, forKey: .symbol)
            let decimals = try container.decode(Int.self, forKey: .decimals)
            var assetType: AssetType = id.hasPrefix("0x") ? .neoAsset : .nep5Token
            
            if id.contains("00000000000000000000000000000000000000") {
                assetType = .ontologyAsset
            }
            
            if id.contains("c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b") || id.contains("602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7") {
                assetType = .neoAsset
            }
            //If the value is given in string format, the assumption is that is coming from the
            // server and it is not ready to use, and needs to be adjusted for decimals
            // Otherwise the value can be given and it doesnt have to be adjusted
            var value = 0.0
            do {
                let valueString = try container.decode(String.self, forKey: .value)
                let valueDecimal = Decimal(string: valueString)
                
                if assetType == .neoAsset {
                    value = Double(truncating: (valueDecimal as NSNumber?)!)
                } else {
                    let dividedBalance = (valueDecimal! / pow(10, decimals))
                    value = Double(truncating: (dividedBalance as NSNumber?)!)
                }
            } catch {
                value = try container.decode(Double.self, forKey: .value)
            }
            
            self.init(id: id, name: name, symbol: symbol, decimals: decimals, value: value, assetType: assetType)
        }
    }
}

extension TransferableAsset {
    
    var formattedBalanceString: String {
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = self.decimals
        amountFormatter.numberStyle = .decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true
        return String(format: "%@", amountFormatter.string(from: NSDecimalNumber(decimal: Decimal(self.value)))!)
    }
}

extension TransferableAsset {
    static func NEO() -> TransferableAsset {
        return TransferableAsset(
            id: AssetId.neoAssetId.rawValue,
            name: "NEO",
            symbol: "NEO",
            decimals: 0,
            value : 0,
//            value: O3Cache.neo().value,
            assetType: .neoAsset)
    }
    
    static func NEONoBalance() -> TransferableAsset {
        return TransferableAsset(
            id: AssetId.neoAssetId.rawValue,
            name: "NEO",
            symbol: "NEO",
            decimals: 0,
            value: 0,
            assetType: .neoAsset)
    }
    
    static func GAS() -> TransferableAsset {
        return TransferableAsset(
            id: AssetId.gasAssetId.rawValue,
            name: "GAS",
            symbol: "GAS",
            decimals: 8,
            value : 0,
//            value: O3Cache.gas().value,
            assetType: .neoAsset)
    }
    
    static func GASNoBalance() -> TransferableAsset {
        return TransferableAsset(
            id: AssetId.gasAssetId.rawValue,
            name: "GAS",
            symbol: "GAS",
            decimals: 8,
            value: 0,
            assetType: .neoAsset)
    }
}
