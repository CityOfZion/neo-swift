//
//  Peer.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 10/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

public struct Peer: Codable {

    public var address: String
    public var port: UInt
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case port = "port"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let address: String = try container.decode(String.self, forKey: .address)
        let port: UInt = try container.decode(UInt.self, forKey: .port)
        self.init(address: address, port: port)
    }
    
    public init(address: String, port: UInt) {
        self.address = address
        self.port = port
    }
}


public struct GetPeersResult: Codable {
    public var unconnected: [Peer]
    public var connected: [Peer]
    public var bad: [Peer]
    
    enum CodingKeys: String, CodingKey {
        case unconnected = "unconnected"
        case connected = "connected"
         case bad = "bad"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let unconnected: [Peer] = try container.decode([Peer].self, forKey: .unconnected)
        let connected: [Peer] = try container.decode([Peer].self, forKey: .connected)
        let bad: [Peer] = try container.decode([Peer].self, forKey: .bad)
        self.init(unconnected: unconnected, connected: connected, bad: bad)
    }
    
    public init(unconnected: [Peer], connected: [Peer], bad: [Peer]) {
        self.unconnected = unconnected
        self.connected = connected
        self.bad = bad
    }
    
}
