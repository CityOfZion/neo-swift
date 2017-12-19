//
//  TransactionAttritbute.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 9/12/17.
//  Copyright © 2017 drei. All rights reserved.
//

public class TransactionAttritbute {
    
    enum AttributeError: Error {
        case TooLongDescription
    }
    
    //http://docs.neo.org/en-us/node/network-protocol.html
    enum Usage : UInt8 {
        case contractHash = 0x00
        case ECDH02 = 0x02
        case ECDH03 = 0x03
        case Script = 0x20
        case Vote = 0x30
        case CertUrl = 0x80
        case DescriptionUrl = 0x81
        case Description = 0x90
        case Hash1 = 0xa1
        case Hash2 = 0xa2
        case Hash3 = 0xa3
        case Hash4 = 0xa4
        case Hash5 = 0xa5
        case Hash6 = 0xa6
        case Hash7 = 0xa7
        case Hash8 = 0xa8
        case Hash9 = 0xa9
        case Hash10 = 0xaa
        case Hash11 = 0xab
        case Hash12 = 0xac
        case Hash13 = 0xad
        case Hash14 = 0xae
        case Hash15 = 0xaf
        
        case Remark = 0xf0
        case Remark1 = 0xf1
        case Remark2 = 0xf2
        case Remark3 = 0xf3
        case Remark4 = 0xf4
        case Remark5 = 0xf5
        case Remark6 = 0xf6
        case Remark7 = 0xf7
        case Remark8 = 0xf8
        case Remark9 = 0xf9
        case Remark10 = 0xfa
        case Remark11 = 0xfb
        case Remark12 = 0xfc
        case Remark13 = 0xfd
        case Remark14 = 0xfe
        case Remark15 = 0xff
    }
    
    public let data: [UInt8]?
    
    public init(description: String)  {
        let byteArray: [UInt8] = Array(description.utf8)
        let length = UInt8(byteArray.count)
        var attribute:[UInt8] = [Usage.Description.rawValue, length]
        attribute = attribute + byteArray
        self.data = attribute
    }
}
