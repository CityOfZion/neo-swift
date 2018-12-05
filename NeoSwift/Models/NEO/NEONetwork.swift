//
//  NEONetwork.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 10/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

@objc public class NEONode: BlockHeight {
    @objc public var URL: String
    
    enum CodingKeys: String, CodingKey {
        case URL = "url"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let heightContainer = try decoder.container(keyedBy: BlockHeightCodingKeys.self)
        let url: String = try container.decode(String.self, forKey: .URL)
        let height: UInt = try heightContainer.decode(UInt.self, forKey: .height)
        self.init(url: url, height: height)
    }
    
    public init(url: String, height: UInt) {
        self.URL = url
        super.init(height: height)
    }
}

@objc public class NEONodes: NSObject, Codable {
    
    @objc public var nodes: [NEONode]
    
    enum CodingKeys: String, CodingKey {
        case nodes = "nodes"
    }
    
    public convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nodes: [NEONode] = try container.decode([NEONode].self, forKey: .nodes)
        self.init(nodes: nodes)
    }
    
    public init(nodes: [NEONode]) {
        self.nodes = nodes
    }
}

@objc public class NEONetwork: NSObject, Codable {
    
    @objc public var mainNet: NEONodes
    @objc public var testNet: NEONodes
    
    enum CodingKeys: String, CodingKey {
        case mainNet = "main"
        case testNet = "test"
    }
    
    public init(mainNodes: NEONodes, testNodes: NEONodes) {
        self.mainNet = mainNodes
        self.testNet = testNodes
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mainNodes: NEONodes = try container.decode(NEONodes.self, forKey: .mainNet)
        let testNodes: NEONodes = try container.decode(NEONodes.self, forKey: .testNet)
        self.init(mainNodes: mainNodes, testNodes: testNodes)
    }
}
