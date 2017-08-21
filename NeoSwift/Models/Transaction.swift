//
//  Transaction.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct Transaction: Codable {
    var transactionID: String
    var size: Int64
    var type: String
    var version: Int64
   // var attributes: [] //Need to handle this, not really sure what kind of objects it can give bakc
    var valueIns: [ValueIn]
    var valueOuts: [ValueOut]
    var systemFee: String
    var networkFee: String
    var scripts: [Script]
   // var nonce: Int64
    
    //TODO: FIGURE OUT THE ATTRIBUTES
    enum CodingKeys : String, CodingKey {
        case transactionID = "txid"
        case size = "size"
        case type = "type"
        case version = "version"
    //   case attributes = "attributes"
        case valueIns = "vin"
        case valueOuts = "vout"
        case systemFee = "sys_fee"
        case networkFee = "net_fee"
        case scripts = "scripts"
        //case nonce = "nonce"
    }
    
    //TODO: MAKE THE TYPE ENUMED
    //TODO MAKE A CLAIM DATASTRUCTURE
    public init (transactionID: String, size: Int64, type: String, version: Int64, /*attributes: String,*/ valueIns: [ValueIn], valueOuts: [ValueOut],
          systemFee: String, networkFee: String, scripts: [Script]/*, nonce: Int64*/) {
        self.transactionID = transactionID
        self.size = size
        self.type = type
        self.version = version
       // self.attributes = attributes
        self.valueIns = valueIns
        self.valueOuts = valueOuts
        self.systemFee = systemFee
        self.networkFee = networkFee
        self.scripts = scripts
        //self.nonce = nonce //NONCE IS ONLY INCLUDED IN MINER TRANSACTIONS? READD LATER
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let transactionID: String = try container.decode(String.self, forKey: .transactionID)
        let size: Int64 = try container.decode(Int64.self, forKey: .size)
        let type: String = try container.decode(String.self, forKey: .type)
        let version: Int64 = try container.decode(Int64.self, forKey: .version)
      //  let attributes: String = try container.decode(String.self, forKey: .attributes)
        let valueIns: [ValueIn] = try container.decode([ValueIn].self, forKey: .valueIns)
        let valueOuts: [ValueOut] = try container.decode([ValueOut].self, forKey: .valueOuts)
        let systemFee: String = try container.decode(String.self, forKey: .systemFee)
        let networkFee: String = try container.decode(String.self, forKey: .networkFee)
        let scripts: [Script] = try container.decode([Script].self, forKey: .scripts)
      //  let nonce: Int64 = try container.decode(Int64.self, forKey: .nonce)
        
        self.init(transactionID: transactionID, size: size, type: type, version: version, /*attributes: attributes,*/ valueIns: valueIns, valueOuts: valueOuts,
                  systemFee: systemFee, networkFee: networkFee, scripts: scripts/*, nonce: nonce*/)
    }
}

