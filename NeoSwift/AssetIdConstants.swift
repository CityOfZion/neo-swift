//
//  AssetIdConstants.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
public enum AssetId: String {
    case neoAssetId = "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
    case gasAssetId = "602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7"
}

func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafeBytes(of: &value) { Array($0) }
}

func toByteArrayWithoutTrailingZeros<T>(_ value: T) -> [UInt8] {
    var value = value
    var arr = withUnsafeBytes(of: &value) { Array($0) }
    arr.removeTrailingZeros()
    return arr
}

