//
//  AsymmetricEncryptionRSA.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 14/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface AsymmetricEncryptionRSA : NSObject {
    SecKeyRef publicKeyRef;
	SecKeyRef privateKeyRef;
    NSData * publicTag;
    NSData * privateTag;
}

-( void )generateKeyPair;
-( NSData * )encryptWithPublicKey: ( NSString * )sUnencryptedPasscode;
-( NSString * )decryptWithPrivateKey: ( NSData * )dataToDecrypt;

@end
