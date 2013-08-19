//
//  PasscodeManager.m
//  Password Manager and File Vault
//
//  Created by Nikhil Divani on 15/08/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "PasscodeManager.h"
 #define kPasscode               @"0000"   

@implementation PasscodeManager

static PasscodeManager* _sharedSingleton = nil;

-(id)init{
    self = [super init];
    if(self)
    {
        keychainObject = [ [ Keychain alloc ] init ];
        dispatch_async(dispatch_queue_create( "uk.co.metrarc_resolve_encrypted_passcode", DISPATCH_QUEUE_CONCURRENT ), ^ {
            [ self _resolveEncryptedPasscode ];
        } );
    }
    
    return self;
}

+(PasscodeManager*)sharedPasscodeManager
{
    @synchronized([PasscodeManager class])
    {
        if (!_sharedSingleton)
            [[self alloc] init];
        return _sharedSingleton;
    }
    return nil;
}

+(id)alloc

{
    @synchronized([PasscodeManager class])
    { NSAssert(_sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedSingleton = [super alloc];
        return _sharedSingleton;
    }
    return nil;
}

    
//    + (void)initialize
//    {
//        static BOOL initialized = NO;
//        if(!initialized)
//        {
//            initialized = YES;
//            sharedSingleton = [[PasscodeManager alloc] init];
//        }
//    }
    
-( NSString * )_getPasscodeValue {
   // NSString *sPasscodeAsString = [ [ NSString alloc ] initWithFormat: @"%@%@%@%@", [ firstPasscodeDigit text ], [ secondPasscodeDigit text ], [ thirdPasscodeDigit text ], [ fourthPasscodeDigit text ] ];
   return @" ";
}


-( NSString *)getDecryptedPasscode
{
    return sDecryptedPasscode;
}

-( void )_resolveEncryptedPasscode {
    // Get encrypted passcode from keychain.
    NSData *encryptedPasscode_data = [ [ NSData alloc ] initWithData: [ keychainObject getDataFromKeychainForService: @"passcode" andAccount: @"login" ] ];
    
    // Decrypt the passcode taken from the keychain.
    AsymmetricEncryptionRSA *asymmetricEncryptionRsa = [ [ AsymmetricEncryptionRSA alloc ] init ];
    [ asymmetricEncryptionRsa generateKeyPair ];
    sDecryptedPasscode = [ asymmetricEncryptionRsa decryptWithPrivateKey: encryptedPasscode_data ];
    NSLog( @"%@", sDecryptedPasscode );
    encryptedPasscode_data = nil;
}

/*
-( IBAction )_setPasscode: ( id )sender {
    [ self encryptPasscode ];
}
 */

-( NSData * )encryptPasscode {
    AsymmetricEncryptionRSA *asymmetricEncryptionRSA = [ [ AsymmetricEncryptionRSA alloc ] init ];
    [ asymmetricEncryptionRSA generateKeyPair ];
    NSData *rsaEncryptedData = [ [ NSData alloc ] initWithData: [ asymmetricEncryptionRSA encryptWithPublicKey: kPasscode ] ];
    keychainObject = [ [ Keychain alloc ] init ];
    [ keychainObject saveDataInKeychainEntryForService: @"passcode" andAccount: @"login" dataToSave: rsaEncryptedData ];
    keychainObject = nil;
    return rsaEncryptedData;
}

@end
