//
//  TransactionModel.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class TransactionModel: NSObject, Codable {
    @objc public var vouts: [NeoScanBaseModel]
    @objc public var vin: [NeoScanBaseModel]
    @objc public var version: Int
    @objc public var type: String
    @objc public var txid: String
    @objc public var time: Int
    @objc public var sys_fee: Double
    @objc public var size: Int
    @objc public var scripts: [Script]
    @objc public var net_fee: Double
    @objc public var claims: [NeoScanBaseModel]
    @objc public var block_height: Int
    @objc public var block_hash: String
    @objc public var attributes: [TransactionModelAttribute]
    
    enum CodingKeys: String, CodingKey {
        case vouts
        case vin
        case version
        case type
        case txid
        case time
        case sys_fee
        case size
        case scripts
        case net_fee
        case claims
        case block_height
        case block_hash
        case attributes
    }
    
    public init(vouts: [NeoScanBaseModel], vin: [NeoScanBaseModel], version: Int, type: String, txid: String, time: Int, sys_fee: Double, size: Int, scripts: [Script], net_fee: Double, claims: [NeoScanBaseModel], block_height: Int, block_hash: String, attributes: [TransactionModelAttribute]) {
        self.vouts = vouts
        self.vin = vin
        self.version = version
        self.type = type
        self.txid = txid
        self.time = time
        self.sys_fee = sys_fee
        self.size = size
        self.scripts = scripts
        self.net_fee = net_fee
        self.claims = claims
        self.block_height = block_height
        self.block_hash = block_hash
        self.attributes = attributes
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let vouts: [NeoScanBaseModel] = try container.decode([NeoScanBaseModel].self, forKey: .vouts)
        let vin: [NeoScanBaseModel] = try container.decode([NeoScanBaseModel].self, forKey: .vin)
        let version: Int = try container.decode(Int.self, forKey: .version)
        let type: String = try container.decode(String.self, forKey: .type)
        let txid: String = try container.decode(String.self, forKey: .txid)
        let time: Int = try container.decode(Int.self, forKey: .time)
        let sys_fee: Double = try container.decode(Double.self, forKey: .sys_fee)
        let size: Int = try container.decode(Int.self, forKey: .size)
        let scripts: [Script] = try container.decode([Script].self, forKey: .scripts)
        let net_fee: Double = try container.decode(Double.self, forKey: .net_fee)
        let claims: [NeoScanBaseModel] = try container.decode([NeoScanBaseModel].self, forKey: .claims)
        let block_height: Int = try container.decode(Int.self, forKey: .block_height)
        let block_hash: String = try container.decode(String.self, forKey: .block_hash)
        let attributes: [TransactionModelAttribute] = try container.decode([TransactionModelAttribute].self, forKey: .attributes)
        self.init(vouts: vouts, vin: vin, version: version, type: type, txid: txid, time: time, sys_fee: sys_fee, size: size, scripts: scripts, net_fee: net_fee, claims: claims, block_height: block_height, block_hash: block_hash, attributes: attributes)
    }

}
