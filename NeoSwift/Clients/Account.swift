//
//  Account.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/25/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neoutils
import Security

public class Account : NSObject, Codable {
    @objc public var wif: String
    @objc public var publicKey: Data
    @objc public var privateKey: Data
    @objc public var address: String
    @objc public var hashedSignature: Data
    
    @objc public var label: String?
    @objc public var key: String?
    @objc public var isDefault = false
    @objc public var lock = false
    @objc public var extra: String?
    
    private enum CodingKeys: String, CodingKey {
        case address
        case label
        case isDefault
        case lock
        case extra
        case key
    }
    
    @objc lazy var publicKeyString: String = {
        return publicKey.hexString
    }()
    
    @objc lazy var privateKeyString: String = {
        return privateKey.hexString
    }()
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(extra, forKey: .extra)
        try container.encode(key, forKey: .key)
        try container.encode(lock, forKey: .lock)
        try container.encode(isDefault, forKey: .isDefault)
        try container.encode(label, forKey: .label)
        try container.encode(address, forKey: .address)
    }
    
    public init(label: String?, address: String, isDefault: Bool, lock: Bool, extra: String?, key: String?) {
        self.wif = ""
        self.publicKey = Data()
        self.privateKey = Data()
        self.hashedSignature = Data()
        
        self.label = label
        self.address = address
        self.isDefault = isDefault
        self.lock = lock
        self.key = key
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label: String? = try container.decode(String?.self, forKey: .label)
        let address: String = try container.decode(String.self, forKey: .address)
        let isDefault: Bool = try container.decode(Bool.self, forKey: .isDefault)
        let lock: Bool = try container.decode(Bool.self, forKey: .lock)
        let extra: String? = try container.decode(String?.self, forKey: .extra)
        let key: String? = try container.decode(String?.self, forKey: .key)
        self.init(label: label, address: address, isDefault: isDefault, lock: lock, extra: extra, key: key)
    }
    
    @objc public init?(wif: String) {
        var error: NSError?
        guard let wallet = NeoutilsGenerateFromWIF(wif, &error) else { return nil }
        self.wif = wif
        self.publicKey = wallet.publicKey()
        self.privateKey = wallet.privateKey()
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }
    
    @objc public init?(privateKey: String) {
        var error: NSError?
        guard let wallet = NeoutilsGenerateFromPrivateKey(privateKey, &error) else { return nil }
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = privateKey.dataWithHexString()
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }
    
    @objc public init?(encryptedPrivateKey: String, passphrase: String) {
        var error: NSError?
        guard let (decryptedKey, hash) = NEP2.decryptKey(encryptedPrivateKey, passphrase: passphrase, scryptParameter: nil) else { return nil }
        guard let wallet = NeoutilsGenerateFromPrivateKey(decryptedKey.hexString, &error) else { return nil }
        
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = Data(decryptedKey)
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
        
        let nep2 = NeoutilsNEP2Encrypt(self.wif, passphrase, &error)
        self.key = nep2?.encryptedKey()
        
        guard NEP2.verify(addressHash: hash, address: wallet.address()) else { return nil }
    }
    
    public override init() {
        let byteCount: Int = 32
        var pkeyData = Data(count: byteCount)
        let result = pkeyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, byteCount, $0)
        }
        
        if result != errSecSuccess {
            fatalError()
        }
        
        var error: NSError?
        guard let wallet = NeoutilsGenerateFromPrivateKey(pkeyData.hexString, &error) else { fatalError() }
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = pkeyData
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }
    
    @objc func decrypt(passphrase: String, scryptParam: Scrypt) {
        guard let encryptedKey = self.key else { return }
        
        var error: NSError?
        guard let (decryptedKey, hash) = NEP2.decryptKey(encryptedKey, passphrase: passphrase, scryptParameter: scryptParam) else { return }
        guard let wallet = NeoutilsGenerateFromPrivateKey(decryptedKey.hexString, &error) else { return }
        
        if wallet.address() == self.address {
            self.wif = wallet.wif()
            self.publicKey = wallet.publicKey()
            self.privateKey = Data(decryptedKey)
            self.hashedSignature = wallet.hashedSignature()
            
            guard NEP2.verify(addressHash: hash, address: wallet.address()) else { return }
        }
    }
    
    @objc func exportKeystoreJson(completion: @escaping (String?, String?) -> Void) {
        if self.key == nil {
            completion(nil, "Encrypt private key first!")
            return
        }
        let wallet = Wallet()
        wallet.accounts.append(self)
        do {
            let data = try JSONEncoder().encode(wallet)
            let json = String(data: data, encoding: .utf8)
            completion(json, nil)
        }
        catch {
            completion(nil, "Unexpected error")
        }
    }
    
    @objc func createSharedSecret(publicKey: Data) -> Data? {
        var error: NSError?
        guard let wallet = NeoutilsGenerateFromPrivateKey(self.privateKey.hexString, &error) else {return nil}
        return wallet.computeSharedSecret(publicKey)
    }
    
    @objc func encryptString(key: Data, text: String) -> String {
        return NeoutilsEncrypt(key, text)
    }
    
    @objc func decryptString(key: Data, text: String) -> String? {
        return NeoutilsDecrypt(key, text)
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
    public func getInputsNecessaryToSendNeo(amount: Double, assets: Assets?) ->
        (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?) {
            
            var sortedUnspents = [UTXO]()
            var neededForTransaction = [UTXO]()
            sortedUnspents = assets!.getSortedNEOUTXOs()
            if sortedUnspents.reduce(0, {$0 + $1.value}) < Decimal(amount) {
                return (nil, nil, nil, NSError())
            }
            
            var runningAmount: Decimal = 0.0
            var index = 0
            var count: UInt8 = 0
            //Assume we always have enough balance to do this, prevent the check for bal
            while runningAmount < Decimal(amount) {
                neededForTransaction.append(sortedUnspents[index])
                runningAmount += sortedUnspents[index].value
                index += 1
                count += 1
            }
            var inputData = [UInt8]()
            for x in 0..<neededForTransaction.count {
                let data = neededForTransaction[x].txid.dataWithHexString()
                let reversedBytes = data.bytes.reversed()
                inputData += reversedBytes + toByteArray(UInt16(neededForTransaction[x].index))
            }
            
            return (runningAmount, count, Data(bytes: inputData), nil)
    }
    
    public func getInputsNecessaryToSendGas(amount: Double, assets: Assets?, fee: Double = 0.0) ->
        (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?) {
            
            //asset less sending
            if assets == nil {
                let inputData = [UInt8]()
                return (0, 0, Data(bytes: inputData), nil)
            }
            
            var sortedUnspents = [UTXO]()
            var neededForTransaction = [UTXO]()
            sortedUnspents = assets!.getSortedGASUTXOs()
            if sortedUnspents.reduce(0, {$0 + $1.value}) < Decimal(amount) {
                return (nil, nil, nil, NSError())
            }
            
            var runningAmount: Decimal = 0.0
            var index = 0
            var count: UInt8 = 0
            //Assume we always have enough balance to do this, prevent the check for bal
            while runningAmount < Decimal(amount) + Decimal(fee) {
                neededForTransaction.append(sortedUnspents[index])
                runningAmount += sortedUnspents[index].value
                index += 1
                count += 1
            }
            var inputData = [UInt8]()
            for x in 0..<neededForTransaction.count {
                let data = neededForTransaction[x].txid.dataWithHexString()
                let reversedBytes = data.bytes.reversed()
                inputData += reversedBytes + toByteArray(UInt16(neededForTransaction[x].index))
            }
            
            return (runningAmount, count, Data(bytes: inputData), nil)
    }
    
    func getAttributesPayload(attributes: [TransactionAttritbute]?) -> [UInt8] {
        var numberOfAttributes: UInt8 = 0x00
        var attributesPayload: [UInt8] = []
        if attributes != nil {
            for attribute in attributes! where attribute.data != nil {
                attributesPayload += attribute.data!
                numberOfAttributes += 1
            }
        }
        return  [numberOfAttributes] + attributesPayload
    }
    
    func getOuputDataPayload(asset: AssetId, with inputData: Data, runningAmount: Decimal,
                             toSendAmount: Double, toAddress: String, fee: Double = 0.0) -> (payload: Data, outputCount: UInt8) {
        let needsTwoOutputTransactions =
            runningAmount != (Decimal(toSendAmount) + Decimal(fee))
        
        var outputCount: UInt8
        var payload: [UInt8] = []
        if runningAmount == Decimal(0) && fee == 0.0 {
            return (Data(bytes: payload), 0)
        }
        
        if needsTwoOutputTransactions {
            //Transaction To Reciever
            outputCount = 2
            payload += asset.rawValue.dataWithHexString().bytes.reversed()
            let amountToSend = toSendAmount * pow(10, 8)
            let amountToSendRounded = round(amountToSend)
            let amountToSendInMemory = UInt64(amountToSendRounded)
            payload += toByteArray(amountToSendInMemory)
            
            //reciever addressHash
            payload += toAddress.hashFromAddress().dataWithHexString()
            
            //Transaction To Sender
            payload += asset.rawValue.dataWithHexString().bytes.reversed()
            let runningAmountRounded = round(NSDecimalNumber(decimal: runningAmount * pow(10, 8)).doubleValue)
            let feeRounded = round(fee * pow(10, 8))
            let amountToGetBack = runningAmountRounded - amountToSendRounded - feeRounded
            let amountToGetBackInMemory = UInt64(amountToGetBack)
            
            payload += toByteArray(amountToGetBackInMemory)
            payload += hashedSignature.bytes
            
        } else {
            outputCount = 1
            payload += asset.rawValue.dataWithHexString().bytes.reversed()
            let amountToSend = toSendAmount * pow(10, 8)
            let amountToSendRounded = round(amountToSend)
            let amountToSendInMemory = UInt64(amountToSendRounded)
            
            payload += toByteArray(amountToSendInMemory)
            payload += toAddress.hashFromAddress().dataWithHexString()
        }
        return (Data(bytes: payload), outputCount)
    }
    
    func concatenatePayloadData(txData: Data, signatureData: Data) -> Data {
        var payload = txData.bytes + [0x01]               // signature number
        payload += [0x41]                                 // signature struct length
        payload += [0x40]                                 // signature data length
        payload += signatureData.bytes                    // signature
        payload += [0x23]                                 // contract data length
        payload += [0x21] + self.publicKey.bytes + [0xac] // NeoSigned publicKey
        return Data(bytes: payload)
    }
    
    func generateSendTransactionPayload(asset: AssetId, amount: Double, toAddress: String, assets: Assets, attributes: [TransactionAttritbute]? = nil, fee: Double = 0.0) -> (Data, Data) {
        var error: NSError?
        
        var mainInputData: (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?)
        var mainOutputData: (payload: Data, outputCount: UInt8)
        var optionalFeeInputData: (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?)? = nil
        if asset == AssetId.gasAssetId {
            mainInputData = getInputsNecessaryToSendGas(amount: amount, assets: assets, fee: fee)
            mainOutputData = getOuputDataPayload(asset: asset, with: mainInputData.payload!,
                                                 runningAmount: mainInputData.totalAmount!,
                                                 toSendAmount: amount, toAddress: toAddress, fee: fee)
            
        } else {
            mainInputData = getInputsNecessaryToSendNeo(amount: amount, assets: assets)
            mainOutputData = getOuputDataPayload(asset: asset, with: mainInputData.payload!,
                                                 runningAmount: mainInputData.totalAmount!,
                                                 toSendAmount: amount, toAddress: toAddress, fee: 0)
            if fee > 0.0 {
                optionalFeeInputData = getInputsNecessaryToSendGas(amount: 0.00000001, assets: assets, fee: fee)
            }
        }
        
        var optionalFeeOutputData: (payload: Data, outputCount: UInt8)? = nil
        if optionalFeeInputData != nil {
            optionalFeeOutputData = getOuputDataPayload(asset: AssetId.gasAssetId, with: (optionalFeeInputData?.payload!)!,
                                                        runningAmount: (optionalFeeInputData?.totalAmount!)!,
                                                        toSendAmount: 0.00000001, toAddress: self.address, fee: fee)
        }
        
        let sendPayloadPrefix: [UInt8] = [0x80, 0x00]
        let attributesPayload = getAttributesPayload(attributes: attributes)
        
        let totalInputCount = (mainInputData.inputCount!) + (optionalFeeInputData?.inputCount ?? 0)
        let finalInputPayload = Data(bytes: (mainInputData.payload!).bytes + (optionalFeeInputData?.payload ?? Data()).bytes)
        
        let totalOutputCount = (mainOutputData.outputCount) + (optionalFeeOutputData?.outputCount ?? 0)
        let finalOutputPayload = Data(bytes: (mainOutputData.payload).bytes + (optionalFeeOutputData?.payload ?? Data()).bytes)
        
        var rawTransaction = sendPayloadPrefix + attributesPayload
        rawTransaction += [totalInputCount] + finalInputPayload.bytes +
            [totalOutputCount] + finalOutputPayload.bytes
        
        let rawTransactionData = Data(bytes: rawTransaction)
        
        let signatureData = NeoutilsSign(rawTransactionData, privateKey.hexString, &error)
        let finalPayload = concatenatePayloadData(txData: rawTransactionData, signatureData: signatureData!)
        return (rawTransactionData, finalPayload)
        
    }
    
    func unsignedPayloadToTransactionId(_ unsignedPayload: Data) -> String {
        let unsignedPayloadString = unsignedPayload.hexString
        let firstHash = unsignedPayloadString.dataWithHexString().sha256.hexString
        let reversed: [UInt8] = firstHash.dataWithHexString().sha256.bytes.reversed()
        return reversed.hexString
    }
    
    private func generateInvokeTransactionPayload(assets: Assets? = nil, script: String, contractAddress: String, attributes: [TransactionAttritbute]?, fee: Double = 0.0) -> (String, Data) {
        var error: NSError?
        let amount = 0.00000001
        
        let mainInputData = getInputsNecessaryToSendGas(amount: amount, assets: assets, fee: fee)
        let mainOutputData = getOuputDataPayload(asset: AssetId.gasAssetId, with: mainInputData.payload!,
                                                 runningAmount: mainInputData.totalAmount!,
                                                 toSendAmount: amount, toAddress: self.address, fee: fee)
        
        let payloadPrefix = [0xd1, 0x00] + script.dataWithHexString().bytes
        
        let attributesPayload = getAttributesPayload(attributes: attributes)
        
        var rawTransaction = payloadPrefix + attributesPayload
        
        rawTransaction += [mainInputData.inputCount!] + mainInputData.payload!.bytes +
            [mainOutputData.outputCount] + mainOutputData.payload.bytes
        
        print(rawTransaction.hexString)
        let rawTransactionData = Data(bytes: rawTransaction)
        
        let signatureData = NeoutilsSign(rawTransactionData, privateKey.hexString, &error)
        let finalPayload = concatenatePayloadData(txData: rawTransactionData, signatureData: signatureData!)
        //hash unsigned tx to get txid
        let txid = self.unsignedPayloadToTransactionId(rawTransactionData)
        return (txid, finalPayload)
    }
    
    private func buildNEP5TransferScript(scriptHash: String, decimals: Int, fromAddress: String,
                                         toAddress: String, amount: Double) -> [UInt8] {
        
        let amountToSend = Int(amount * pow(10, Double(decimals)))
        let fromAddressHash = fromAddress.hashFromAddress()
        let toAddressHash = toAddress.hashFromAddress()
        let scriptBuilder = ScriptBuilder()
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "transfer",
                                         args: [amountToSend, toAddressHash, fromAddressHash])
        let script = scriptBuilder.rawBytes
        return [UInt8(script.count)] + script
    }
    
    private func buildInvocationScript(method: String, scriptHash: String, fromAddress: String) -> [UInt8] {
        let fromAddressHash = fromAddress.hashFromAddress()
        let scriptBuilder = ScriptBuilder()
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: method,
                                         args: [fromAddressHash])
        let script = scriptBuilder.rawBytes
        return [UInt8(script.count)] + script
    }
    
    @objc public func sendNep5Token(seedURL: String, contractScripthash: String, decimals: Int, amount: Double, toAddress: String,
                              attributes: [TransactionAttritbute]? = nil, completion: @escaping(Bool, NeoClientError?, String?) -> Void) {
        
        var customAttributes: [TransactionAttritbute] = []
        customAttributes.append(TransactionAttritbute(script: self.address.hashFromAddress()))
        let remark = String(format: "O3X%@", Date().timeIntervalSince1970.description)
        customAttributes.append(TransactionAttritbute(remark: remark))
        customAttributes.append(TransactionAttritbute(descriptionHex: contractScripthash))
        
        //send nep5 token without using utxo
        let scriptBytes = self.buildNEP5TransferScript(scriptHash: contractScripthash, decimals: decimals,
                                                       fromAddress: self.address, toAddress: toAddress, amount: amount)
        
        var payload = self.generateInvokeTransactionPayload(script: scriptBytes.hexString,
                                                            contractAddress: contractScripthash, attributes: customAttributes, fee: 0.0)
        payload.1 += contractScripthash.dataWithHexString().bytes
        #if DEBUG
        print(payload.1.hexString)
        #endif
        let txID = payload.0
        NeoClient(seed: seedURL).sendRawTransaction(with: payload.1) { (result, error) in
            completion(result, error, txID)
        }
    }
    
    @objc public func invokeContractFunction(seedURL: String, method: String, contractScripthash: String, completion: @escaping(Bool, NeoClientError?) -> Void) {
        var customAttributes: [TransactionAttritbute] = []
        customAttributes.append(TransactionAttritbute(script: self.address.hashFromAddress()))
        let remark = String(format: "O3X%@", Date().timeIntervalSince1970.description)
        customAttributes.append(TransactionAttritbute(remark: remark))
        customAttributes.append(TransactionAttritbute(descriptionHex: contractScripthash))
        
        let scriptBytes = self.buildInvocationScript(method: method,
                                                     scriptHash: contractScripthash,
                                                     fromAddress: self.address)
        
        var payload = self.generateInvokeTransactionPayload(assets: nil, script: scriptBytes.hexString,
                                                            contractAddress: contractScripthash, attributes: customAttributes )
        payload.1 += contractScripthash.dataWithHexString().bytes
        #if DEBUG
        print(payload.1.hexString)
        #endif
        NeoClient(seed: seedURL).sendRawTransaction(with: payload.1, completion: completion)
    }
}
