//
//  TransferableAssetExtension.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 10/10/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

extension TransferableAsset {
    var formattedBalanceString: String {
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = self.decimals
        amountFormatter.numberStyle = .decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true
        return String(format: "%@", amountFormatter.string(from: NSDecimalNumber(decimal: Decimal(self.value)))!)
    }
    
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
