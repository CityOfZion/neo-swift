//
//  Account.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/25/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neowallet
import Security

public class Account {
    public var wif: String
    public var publicKey: Data
    public var privateKey: Data
    public var address: String
    public var hashedSignature: Data
    
    lazy var publicKeyString : String = {
        return publicKey.bytes.toHexString()
    }()
    
    lazy var privateKeyString : String = {
        return privateKey.bytes.toHexString()
    }()
    
    public init?(wif: String) {
        var error: NSError?
        guard let wallet = GoNeowalletGenerateFromWIF(wif, &error) else { return nil }
        self.wif = wif
        self.publicKey = wallet.publicKey()
        self.privateKey = wallet.privateKey()
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }
    
    public init?(privateKey: String) {
        var error: NSError?
        guard let wallet = GoNeowalletGeneratePublicKeyFromPrivateKey(privateKey, &error) else { return nil }
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = privateKey.dataWithHexString()
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }
    
    public init?() {
        var pkeyData = Data(count: 32)
        let result = pkeyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, pkeyData.count, $0)
        }
        
        if result != errSecSuccess {
            fatalError()
        }
        
        var error: NSError?
        guard let wallet = GoNeowalletGeneratePublicKeyFromPrivateKey(pkeyData.toHexString(), &error) else { return nil }
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = pkeyData
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }
    
    func getBalance(completion: @escaping(Assets?, Error?) -> Void) {
        NeoClient.shared.getAssets(for: self.address, params: []) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let assets):
                completion(assets, nil)
            }
        }
    }
    
    /*
     * Every asset has a list of transaction ouputs representing the total balance
     * For example your total NEO could be represented as a list [tx1, tx2, tx3]
     * and each element contains an individual amount. So your total balance would
     * be represented as SUM([tx1.amount, tx2.amount, tx3.amount]) In order to make
     * a new transaction we will need to find which inputs are necessary in order to
     * satisfy the condition that SUM(Inputs) >= amountToSend
     *
     * We will attempt to get rid of the the smallest inputs first. So we will sort
     * the list of unspents in ascending order, and then keep a running sum until we
     * meet the condition SUM(Inputs) >= amountToSend. If the SUM(Inputs) == amountToSend 
     * then we will have one transaction output since no change needs to be returned
     * to the sender. If Sum(Inputs) > amountToSend then we will need two transaction
     * outputs, one that sends the amountToSend to the reciever and one that sends
     * Sum(Inputs) - amountToSend back to the sender, thereby returning the change.
     *
     * Input Payload Structure (where each Transaction Input is 34 bytes ). Let n be the
     * number of input transactions necessary | Inputs.count | Tx1 | Tx2 |....| Txn |
     *
     *
     *                             * Input Data Detailed View *
     * |    1 byte    |         32 bytes         |       2 bytes     | 34 * (n - 2) | 34 bytes |
     * | Inputs.count | TransactionId (Reversed) | Transaction Index | ............ |   Txn    |
     *
     *
     *
     *                                               * Final Payload *
     * | 3 bytes  |    1 + (n * 34) bytes     | 1 byte | 32 bytes |     16 bytes (Int64)     |       32 bytes        |
     * | 0x800000 | Input Data Detailed Above |  0x02  |  assetID | toSendAmount * 100000000 | reciever address Hash |
     *
     *
     * |                    16 bytes (Int64)                    |       32 bytes      |  3 bytes |
     * | (totalAmount * 100000000) - (toSendAmount * 100000000) | sender address Hash | 0x014140 |
     *
     *
     * |    32 bytes    |      34 bytes        |
     * | Signature Data | NeoSigned public key |
     *
     * NEED TO DOUBLE CHECK THE BYTE COUNT HERE
     */
    public func getInputsNecessaryToSendAsset(asset: AssetId, amount: Double, assets: Assets) -> (totalAmount: Double?, payload: Data?, error: Error?) {
        var sortedUnspents = [Unspent]()
        var neededForTransaction = [Unspent]()
        if asset == .neoAssetId {
            if assets.neo.balance < amount {
                return (nil, nil, NSError())
            }
            sortedUnspents = assets.neo.unspent.sorted {$0.value < $1.value }
        } else {
            if assets.gas.balance < amount {
                return (nil, nil, NSError())
            }
            sortedUnspents = assets.gas.unspent.sorted { $0.value < $1.value }
        }
        var runningAmount = 0.0
        var index = 0
        var count: UInt8 = 0
        //Assume we always have anough balance to do this, prevent the check for bal
        while runningAmount < amount {
            neededForTransaction.append(sortedUnspents[index])
            runningAmount = runningAmount + sortedUnspents[index].value
            index = index + 1
            count = count + 1
        }
        var inputData = [UInt8]()
        inputData.append(count)
        for x in 0..<neededForTransaction.count {
            let data = neededForTransaction[x].txId.dataWithHexString()
            let reversedBytes = data.bytes.reversed()
            inputData = inputData + reversedBytes + toByteArray(UInt16(neededForTransaction[x].index))
        }
        
        return (runningAmount, Data(bytes: inputData), nil)
    }
    
    func packRawTransactionBytes(asset: AssetId, with inputData: Data, runningAmount: Double, toSendAmount: Double, toAddress: String) -> Data {
        let inputDataBytes = inputData.bytes
        let needsTwoOutputTransactions = runningAmount != toSendAmount
        let payloadLength = needsTwoOutputTransactions ? inputDataBytes.count + 124 : inputDataBytes.count + 64
        var payload: [UInt8] = [0x80, 0x00, 0x00]
        payload = payload + inputDataBytes
        if needsTwoOutputTransactions {
            //Transaction To Reciever
            payload = payload + [0x02] + asset.rawValue.dataWithHexString().bytes.reversed()
            let amountToSendInMemory = UInt64(toSendAmount * 100000000)
            payload = payload + toByteArray(amountToSendInMemory)
            
            //reciever addressHash
            payload = payload + toAddress.hashFromAddress().dataWithHexString()
            
            //Transaction To Sender
            payload = payload + asset.rawValue.dataWithHexString().bytes.reversed()
            let amountToGetBackInMemory = UInt64(runningAmount * 100000000) - UInt64(toSendAmount * 100000000)
            payload = payload + toByteArray(amountToGetBackInMemory)
            payload = payload + hashedSignature.bytes
            
        } else {
            payload = payload + [0x01] + asset.rawValue.dataWithHexString().bytes.reversed()
            let amountToSendInMemory = UInt64(toSendAmount * 100000000)
            payload = payload + toByteArray(amountToSendInMemory)
            payload = payload + toAddress.hashFromAddress().dataWithHexString()
        }
        return Data(bytes: payload)
    }
    
    func concatenatePayloadData(txData: Data, signatureData: Data) -> Data {
        var payload = txData.bytes + [0x01]                        // signature number
        payload = payload + [0x41]                                 // signature struct length
        payload = payload + [0x40]                                 // signature data length
        payload = payload + signatureData.bytes                    // signature
        payload = payload + [0x23]                                 // contract data length
        payload = payload + [0x21] + self.publicKey.bytes + [0xac] // NeoSigned publicKey
        return Data(bytes: payload)
    }
    
    func generateSendTransactionPayload(asset: AssetId, amount: Double, toAddress: String, assets: Assets) -> Data {
        var error: NSError?
        let inputData = getInputsNecessaryToSendAsset(asset: asset, amount: amount, assets: assets)
        let rawTransaction = packRawTransactionBytes(asset: asset, with: inputData.payload!, runningAmount: inputData.totalAmount!,
                                                    toSendAmount: amount, toAddress: toAddress)
        let signatureData = GoNeowalletSign(rawTransaction, privateKey.toHexString(), &error)
        let finalPayload = concatenatePayloadData(txData: rawTransaction, signatureData: signatureData!)
        return finalPayload
        
    }


    public func sendAssetTransaction(asset: AssetId, amount: Double, toAddress: String, completion: @escaping(Bool?, Error?) -> Void) {
        NeoClient.shared.getAssets(for: self.address, params: []) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let assets):
                let payload = self.generateSendTransactionPayload(asset: asset, amount: amount, toAddress: toAddress, assets: assets)
                NeoClient.shared.sendRawTransaction(with: payload) { (result) in
                    switch result {
                    case .failure(let error):
                        completion(nil, error)
                    case .success(let response):
                        completion(response, nil)
                    }
                }
            }
        }
    }
}
