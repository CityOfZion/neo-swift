// Objective-C API for talking to golang.org/x/mobile/example/neo-wallet-address-go Go package.
//   gobind -lang=objc golang.org/x/mobile/example/neo-wallet-address-go
//
// File is generated by gobind. Do not edit.

#ifndef __GoNeowallet_H__
#define __GoNeowallet_H__

@import Foundation;
#include "GoUniverse.objc.h"


@class GoNeowalletWallet;

@interface GoNeowalletWallet : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (id)initWithRef:(id)ref;
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
@end

FOUNDATION_EXPORT GoNeowalletWallet* GoNeowalletGenerateFromWIF(NSString* wif, NSError** error);

FOUNDATION_EXPORT GoNeowalletWallet* GoNeowalletGeneratePublicKeyFromPrivateKey(NSString* privateKey, NSError** error);

#endif
