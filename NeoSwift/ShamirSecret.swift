//
//  ShamirSecret.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 2/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import Neoutils

public class ShamirSecret {
    var secret: NeoutilsSharedSecret!
    init(wif: String) {
        var error: NSError?
        guard let secret = NeoutilsGenerateShamirSharedSecret(wif, &error) else { return }
        self.secret = secret
    }
    
    func getFirst() -> String {
        return secret.first().fullHexString
    }
    
    func getSecond() -> String {
        return secret.second().fullHexString
    }
    
    static func recoverWIFFromPieces(first: Data, second: Data) -> String? {
        var error: NSError?
        guard let secret = NeoutilsRecoverFromSharedSecret(first, second, &error) else { return nil }
        return secret
    }
}
