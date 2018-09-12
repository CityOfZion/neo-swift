// Objective-C API for talking to github.com/o3labs/neo-utils/neoutils Go package.
//   gobind -lang=objc github.com/o3labs/neo-utils/neoutils
//
// File is generated by gobind. Do not edit.

#ifndef __Neoutils_H__
#define __Neoutils_H__

@import Foundation;
#include "Universe.objc.h"


@class NeoutilsBlockCountResponse;
@class NeoutilsFetchSeedRequest;
@class NeoutilsMultiSig;
@class NeoutilsNEP2;
@class NeoutilsNEP5;
@class NeoutilsNativeAsset;
@class NeoutilsNodeList;
@class NeoutilsRawTransaction;
@class NeoutilsSeedNodeResponse;
@class NeoutilsSharedSecret;
@class NeoutilsSimplifiedNEP9;
@class NeoutilsSmartContract;
@class NeoutilsWallet;
@protocol NeoutilsMultiSigInterface;
@class NeoutilsMultiSigInterface;
@protocol NeoutilsNEP5Interface;
@class NeoutilsNEP5Interface;
@protocol NeoutilsNativeAssetInterface;
@class NeoutilsNativeAssetInterface;
@protocol NeoutilsSmartContractInterface;
@class NeoutilsSmartContractInterface;

@protocol NeoutilsMultiSigInterface <NSObject>
// skipped method MultiSigInterface.CreateMultiSigRedeemScript with unsupported parameter or return types

@end

@protocol NeoutilsNEP5Interface <NSObject>
// skipped method NEP5Interface.MintTokensRawTransaction with unsupported parameter or return types

// skipped method NEP5Interface.TransferNEP5RawTransaction with unsupported parameter or return types

@end

@protocol NeoutilsNativeAssetInterface <NSObject>
// skipped method NativeAssetInterface.GenerateRawTx with unsupported parameter or return types

// skipped method NativeAssetInterface.SendNativeAssetRawTransaction with unsupported parameter or return types

@end

@protocol NeoutilsSmartContractInterface <NSObject>
// skipped method SmartContractInterface.GenerateInvokeFunctionRawTransaction with unsupported parameter or return types

// skipped method SmartContractInterface.GenerateInvokeFunctionRawTransactionWithAmountToSend with unsupported parameter or return types

@end

@interface NeoutilsBlockCountResponse : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)jsonrpc;
- (void)setJsonrpc:(NSString*)v;
- (long)id_;
- (void)setID:(long)v;
- (long)result;
- (void)setResult:(long)v;
- (int64_t)responseTime;
- (void)setResponseTime:(int64_t)v;
@end

@interface NeoutilsFetchSeedRequest : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NeoutilsBlockCountResponse*)response;
- (void)setResponse:(NeoutilsBlockCountResponse*)v;
- (NSString*)url;
- (void)setURL:(NSString*)v;
@end

@interface NeoutilsMultiSig : NSObject <goSeqRefInterface, NeoutilsMultiSigInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped method MultiSig.CreateMultiSigRedeemScript with unsupported parameter or return types

@end

@interface NeoutilsNEP2 : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)encryptedKey;
- (void)setEncryptedKey:(NSString*)v;
- (NSString*)address;
- (void)setAddress:(NSString*)v;
@end

@interface NeoutilsNEP5 : NSObject <goSeqRefInterface, NeoutilsNEP5Interface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field NEP5.ScriptHash with unsupported type: github.com/o3labs/neo-utils/neoutils/smartcontract.ScriptHash

// skipped field NEP5.NetworkFeeAmount with unsupported type: github.com/o3labs/neo-utils/neoutils/smartcontract.NetworkFeeAmount

// skipped method NEP5.MintTokensRawTransaction with unsupported parameter or return types

// skipped method NEP5.TransferNEP5RawTransaction with unsupported parameter or return types

@end

@interface NeoutilsNativeAsset : NSObject <goSeqRefInterface, NeoutilsNativeAssetInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field NativeAsset.NetworkFeeAmount with unsupported type: github.com/o3labs/neo-utils/neoutils/smartcontract.NetworkFeeAmount

// skipped method NativeAsset.GenerateRawTx with unsupported parameter or return types

// skipped method NativeAsset.SendNativeAssetRawTransaction with unsupported parameter or return types

@end

@interface NeoutilsNodeList : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field NodeList.URL with unsupported type: []string

@end

@interface NeoutilsRawTransaction : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)txid;
- (void)setTXID:(NSString*)v;
- (NSData*)data;
- (void)setData:(NSData*)v;
@end

@interface NeoutilsSeedNodeResponse : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)url;
- (void)setURL:(NSString*)v;
- (long)blockCount;
- (void)setBlockCount:(long)v;
- (int64_t)responseTime;
- (void)setResponseTime:(int64_t)v;
@end

/**
 * Shared Secret with 2 parts.
 */
@interface NeoutilsSharedSecret : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSData*)first;
- (void)setFirst:(NSData*)v;
- (NSData*)second;
- (void)setSecond:(NSData*)v;
@end

@interface NeoutilsSimplifiedNEP9 : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)to;
- (void)setTo:(NSString*)v;
- (NSString*)asset;
- (void)setAsset:(NSString*)v;
- (double)amount;
- (void)setAmount:(double)v;
@end

@interface NeoutilsSmartContract : NSObject <goSeqRefInterface, NeoutilsSmartContractInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field SmartContract.ScriptHash with unsupported type: github.com/o3labs/neo-utils/neoutils/smartcontract.ScriptHash

// skipped field SmartContract.NetworkFeeAmount with unsupported type: github.com/o3labs/neo-utils/neoutils/smartcontract.NetworkFeeAmount

// skipped method SmartContract.GenerateInvokeFunctionRawTransaction with unsupported parameter or return types

// skipped method SmartContract.GenerateInvokeFunctionRawTransactionWithAmountToSend with unsupported parameter or return types

@end

@interface NeoutilsWallet : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
/**
 * Create a new wallet.
 */
- (instancetype)init;
- (NSData*)publicKey;
- (void)setPublicKey:(NSData*)v;
- (NSData*)privateKey;
- (void)setPrivateKey:(NSData*)v;
- (NSString*)address;
- (void)setAddress:(NSString*)v;
- (NSString*)wif;
- (void)setWIF:(NSString*)v;
- (NSData*)hashedSignature;
- (void)setHashedSignature:(NSData*)v;
/**
 * Compute shared secret using ECDH
 */
- (NSData*)computeSharedSecret:(NSData*)publicKey;
@end

FOUNDATION_EXPORT NSString* const NeoutilsVERSION;

/**
 * Simple bytes to Hex
 */
FOUNDATION_EXPORT NSString* NeoutilsBytesToHex(NSData* b);

FOUNDATION_EXPORT NSString* NeoutilsClaimONG(NSString* endpoint, long gasPrice, long gasLimit, NSString* wif, NSError** error);

// skipped function ConvertByteArrayToBigInt with unsupported parameter or return types


/**
 * Decrypt AES encrypted string in base64 format to decrypted string
 */
FOUNDATION_EXPORT NSString* NeoutilsDecrypt(NSData* key, NSString* encryptedText);

/**
 * Encrypt string to base64 format using AES
 */
FOUNDATION_EXPORT NSString* NeoutilsEncrypt(NSData* key, NSString* text);

/**
 * Generate a wallet from a private key
 */
FOUNDATION_EXPORT NeoutilsWallet* NeoutilsGenerateFromPrivateKey(NSString* privateKey, NSError** error);

/**
 * Generate a wallet from a WIF
 */
FOUNDATION_EXPORT NeoutilsWallet* NeoutilsGenerateFromWIF(NSString* wif, NSError** error);

FOUNDATION_EXPORT NSString* NeoutilsGenerateNEP6FromEncryptedKey(NSString* walletName, NSString* addressLabel, NSString* address, NSString* encryptedKey);

/**
 * Generate Shamir shared secret to SharedSecret struct.
 */
FOUNDATION_EXPORT NeoutilsSharedSecret* NeoutilsGenerateShamirSharedSecret(NSString* secret, NSError** error);

FOUNDATION_EXPORT NSData* NeoutilsHash160(NSData* data);

FOUNDATION_EXPORT NSData* NeoutilsHash256(NSData* b);

/**
 * Simple hex string to bytes
 */
FOUNDATION_EXPORT NSData* NeoutilsHexTobytes(NSString* hexstring);

FOUNDATION_EXPORT NeoutilsRawTransaction* NeoutilsMintTokensRawTransactionMobile(NSString* network, NSString* scriptHash, NSString* wif, NSString* sendingAssetID, double amount, NSString* remark, double networkFeeAmountInGAS, NSError** error);

// skipped function NEOAddressToScriptHashWithEndian with unsupported parameter or return types


FOUNDATION_EXPORT NSString* NeoutilsNEP2Decrypt(NSString* key, NSString* passphrase, NSError** error);

FOUNDATION_EXPORT NeoutilsNEP2* NeoutilsNEP2Encrypt(NSString* wif, NSString* passphrase, NSError** error);

/**
 * Create a new wallet.
 */
FOUNDATION_EXPORT NeoutilsWallet* NeoutilsNewWallet(NSError** error);

FOUNDATION_EXPORT NSString* NeoutilsOntologyTransfer(NSString* endpoint, long gasPrice, long gasLimit, NSString* wif, NSString* asset, NSString* to, double amount, NSError** error);

FOUNDATION_EXPORT NeoutilsSimplifiedNEP9* NeoutilsParseNEP9URI(NSString* uri, NSError** error);

FOUNDATION_EXPORT NSString* NeoutilsPublicKeyToNEOAddress(NSData* publicKeyBytes);

/**
 * Recover the secret from shared secrets.
 */
FOUNDATION_EXPORT NSString* NeoutilsRecoverFromSharedSecret(NSData* first, NSData* second, NSError** error);

FOUNDATION_EXPORT NSData* NeoutilsReverseBytes(NSData* b);

/**
 * Convert script hash to NEO address
This method takes Big Endian Script hash
 */
FOUNDATION_EXPORT NSString* NeoutilsScriptHashToNEOAddress(NSString* scriptHash);

FOUNDATION_EXPORT NeoutilsSeedNodeResponse* NeoutilsSelectBestSeedNode(NSString* commaSeparatedURLs);

/**
 * Sign data using ECDSA with a private key
 */
FOUNDATION_EXPORT NSData* NeoutilsSign(NSData* data, NSString* key, NSError** error);

// skipped function UseNEP5WithNetworkFee with unsupported parameter or return types


// skipped function UseNativeAsset with unsupported parameter or return types


FOUNDATION_EXPORT id<NeoutilsSmartContractInterface> NeoutilsUseSmartContract(NSString* scriptHashHex);

// skipped function UseSmartContractWithNetworkFee with unsupported parameter or return types


FOUNDATION_EXPORT NSString* NeoutilsVMCodeToNEOAddress(NSData* vmCode);

/**
 * Validate NEO address
 */
FOUNDATION_EXPORT BOOL NeoutilsValidateNEOAddress(NSString* address);

/**
 * Verify signed hash using public key
 */
FOUNDATION_EXPORT BOOL NeoutilsVerify(NSData* publicKey, NSData* signature, NSData* hash);

@class NeoutilsMultiSigInterface;

@class NeoutilsNEP5Interface;

@class NeoutilsNativeAssetInterface;

@class NeoutilsSmartContractInterface;

@interface NeoutilsMultiSigInterface : NSObject <goSeqRefInterface, NeoutilsMultiSigInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
// skipped method MultiSigInterface.CreateMultiSigRedeemScript with unsupported parameter or return types

@end

@interface NeoutilsNEP5Interface : NSObject <goSeqRefInterface, NeoutilsNEP5Interface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
// skipped method NEP5Interface.MintTokensRawTransaction with unsupported parameter or return types

// skipped method NEP5Interface.TransferNEP5RawTransaction with unsupported parameter or return types

@end

@interface NeoutilsNativeAssetInterface : NSObject <goSeqRefInterface, NeoutilsNativeAssetInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
// skipped method NativeAssetInterface.GenerateRawTx with unsupported parameter or return types

// skipped method NativeAssetInterface.SendNativeAssetRawTransaction with unsupported parameter or return types

@end

@interface NeoutilsSmartContractInterface : NSObject <goSeqRefInterface, NeoutilsSmartContractInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
// skipped method SmartContractInterface.GenerateInvokeFunctionRawTransaction with unsupported parameter or return types

// skipped method SmartContractInterface.GenerateInvokeFunctionRawTransactionWithAmountToSend with unsupported parameter or return types

@end

#endif
