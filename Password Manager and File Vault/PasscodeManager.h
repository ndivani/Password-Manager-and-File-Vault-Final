//
//  PasscodeManager.h
//  Password Manager and File Vault
//
//  Created by Nikhil Divani on 15/08/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keychain.h"
#import "AsymmetricEncryptionRSA.h"

@interface PasscodeManager : NSObject{
    Keychain *keychainObject;

    NSString *sDecryptedPasscode;
}

+(PasscodeManager*) sharedPasscodeManager;
-( NSString * )_getPasscodeValue;

-( NSString *)getDecryptedPasscode;

-( void )_resolveEncryptedPasscode;

-( IBAction )_setPasscode: ( id )sender;

-( NSData * )encryptPasscode ;

@end