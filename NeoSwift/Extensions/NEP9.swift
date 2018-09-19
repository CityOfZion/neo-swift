//
//  NEP9.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 2/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import Neoutils

public class NEP9 {
    public typealias NEP9 = NeoutilsSimplifiedNEP9
    public static func parse(_ uri: String) -> NEP9? {
        var error: NSError?
        guard let uri = NeoutilsParseNEP9URI(uri, &error) else { return nil }
        return uri
    }
}
