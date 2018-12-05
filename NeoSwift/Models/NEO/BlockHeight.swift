//
//  BlockHeight.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 05/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

@objc public class BlockHeight: NSObject, Codable {
    @objc public var height: UInt
    
    enum BlockHeightCodingKeys: String, CodingKey {
        case height = "height"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BlockHeightCodingKeys.self)
        let height: UInt = try container.decode(UInt.self, forKey: .height)
        self.init(height: height)
    }
    
    public init(height: UInt) {
        self.height = height
    }
}
