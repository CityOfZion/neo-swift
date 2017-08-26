

//
//  Account.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/25/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neowallet

public class Account {
    var wif: String
    var publicKey: Data
    var privateKey: Data
    var address: String
    var hashedSignature: Data
    
    public init(wif: String) {
        var error: NSError?
        let wallet = GoNeowalletGenerateFromWIF(wif, &error)
        self.wif = wif
        self.publicKey = (wallet?.publicKey())!
        self.privateKey = (wallet?.privateKey())!
        self.address = (wallet?.address())!
        self.hashedSignature = (wallet?.hashedSignature())!
    }
    
    /*
    func sendAssetTransaction(asset: AssetId, amount: Int) { //make amount a non integer value
        coindData = ["assetId": asset.rawValue,
                     "list": ??,
                     "balance]
    }*/
        
        
        /*
        export const sendAssetTransaction = (net, toAddress, fromWif, assetType, amount) => {
            let assetId, assetName, assetSymbol;
            if (assetType === "Neo"){
                assetId = neoId;
            } else {
                assetId = gasId;
            }
            const fromAccount = getAccountsFromWIFKey(fromWif)[0];
            return getBalance(net, fromAccount.address).then((response) => {
                const coinsData = {
                    "assetid": assetId,
                    "list": response.unspent[assetType],
                    "balance": response[assetType],
                    "name": assetType
                }
                const txData = transferTransaction(coinsData, fromAccount.publickeyEncoded, toAddress, amount);
                const sign = signatureData(txData, fromAccount.privatekey);
                const txRawData = addContract(txData, sign, fromAccount.publickeyEncoded);
                return queryRPC(net, "sendrawtransaction", [txRawData], 4);
                });
        };
    }*/
}
