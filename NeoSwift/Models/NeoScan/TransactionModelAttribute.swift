//
//  TransactionModelAttribute.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class TransactionModelAttribute: NSObject, Codable {
    @objc public var usage: String
    @objc public var data: String
    
    enum CodingKeys: String, CodingKey {
        case usage
        case data
    }
    
    public init(usage: String, data: String) {
        self.usage = usage
        self.data = data
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let usage: String = try container.decode(String.self, forKey: .usage)
        let data: String = try container.decode(String.self, forKey: .data)
        self.init(usage: usage, data: data)
    }

}
