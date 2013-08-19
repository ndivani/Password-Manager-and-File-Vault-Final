//
//  AsymmetricEncryptionRSA.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 14/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "AsymmetricEncryptionRSA.h"
static const UInt8 publicKeyIdentifier[] = "com.apple.sample.publickey\0";
static const UInt8 privateKeyIdentifier[] = "com.apple.sample.privatekey\0";

@implementation AsymmetricEncryptionRSA

-( void )generateKeyPair {
    OSStatus status = noErr;
    NSMutableDictionary *privateKeyAttr = [ [ NSMutableDictionary alloc ] init ];
    NSMutableDictionary *publicKeyAttr = [ [ NSMutableDictionary alloc ] init ];
    NSMutableDictionary *keyPairAttr = [ [ NSMutableDictionary alloc ] init ];
    // Allocates dictionaries to be used for attributes in the SecKeyGeneratePair function.

    publicTag = [ NSData dataWithBytes: publicKeyIdentifier
                                        length: strlen( ( const char * )publicKeyIdentifier ) ];
    privateTag = [ NSData dataWithBytes: privateKeyIdentifier
                                         length: strlen( ( const char * )privateKeyIdentifier ) ];
    // Creates NSData objects that contain the identifier strings.

    SecKeyRef publicKey = NULL;
    SecKeyRef privateKey = NULL;                                        // Allocates SecKeyRef objects for the public and private keys.

    [ keyPairAttr setObject: ( __bridge id )kSecAttrKeyTypeRSA
                    forKey: ( __bridge id )kSecAttrKeyType ];           // Sets the key-type attribute for the key pair to RSA.
    [ keyPairAttr setObject: [ NSNumber numberWithInt: 1024 ]
                    forKey: ( __bridge id )kSecAttrKeySizeInBits ];     // Sets the key-size attribute for the key pair to 1024 bits.

    [ privateKeyAttr setObject: [ NSNumber numberWithBool: YES ]
                       forKey: ( __bridge id )kSecAttrIsPermanent ];    // Sets an attribute specifying that the private key is to be stored permanently (that is, put into the keychain).
    [ privateKeyAttr setObject: privateTag
                       forKey: ( __bridge id )kSecAttrApplicationTag ]; // Adds the identifier string defined in lines 22 and 24 to the dictionary for the private key.

    [ publicKeyAttr setObject: [ NSNumber numberWithBool: YES ]
                      forKey: ( __bridge id )kSecAttrIsPermanent ];     // Sets an attribute specifying that the public key is to be stored permanently (that is, put into the keychain).
    [ publicKeyAttr setObject: publicTag
                      forKey: ( __bridge id )kSecAttrApplicationTag ];  // Adds the identifier string defined in lines 22 and 24 to the dictionary for the public key.

    [ keyPairAttr setObject: privateKeyAttr
                    forKey: ( __bridge id )kSecPrivateKeyAttrs ];       // Adds the dictionary of private key attributes to the key-pair dictionary.
    [ keyPairAttr setObject: publicKeyAttr
                    forKey: ( __bridge id )kSecPublicKeyAttrs ];        // Adds the dictionary of public key attributes to the key-pair dictionary.

    status = SecKeyGeneratePair( ( __bridge CFDictionaryRef )keyPairAttr,
                                &publicKey, &privateKey );              // Generate the key pair.

    // Release memory that is no longer needed.
    if( publicKey )     CFRelease( publicKey );
    if( privateKey )    CFRelease( privateKey );
}

-( NSData * )encryptWithPublicKey: ( NSString * )sUnencryptedPasscode {
    NSData *encryption_Data = [ [ NSData alloc ] initWithData: [ sUnencryptedPasscode dataUsingEncoding: NSUTF8StringEncoding ] ];
    SecKeyRef publicKey = [ self getPublicKeyRef ];
    size_t encryptedLength = SecKeyGetBlockSize( publicKey );

    uint8_t *sample = ( uint8_t * )[ encryption_Data bytes ];
    size_t text_Size = [ encryption_Data length ];
    uint8_t *encrypted_Data_Bytes;
    encrypted_Data_Bytes = malloc( sizeof( uint8_t )*encryptedLength );
    memset( encrypted_Data_Bytes, 0, encryptedLength );
    OSStatus status = SecKeyEncrypt( publicKey,
                                     kSecPaddingPKCS1,
                                     sample,
                                     text_Size,
                                     &encrypted_Data_Bytes[ 0 ],
                                     &encryptedLength
                                    );
    if( publicKey )  CFRelease( publicKey );
    NSData *encryptedData = [ [ NSData alloc ] initWithBytes: ( const void * )encrypted_Data_Bytes length: encryptedLength ];
    free( encrypted_Data_Bytes );

    return encryptedData;
}

-( NSString * )decryptWithPrivateKey: ( NSData * )dataToDecrypt {
    const unsigned char* original_String = ( unsigned char * )[ dataToDecrypt bytes ];
    SecKeyRef privateKey = [ self getPrivateKeyRef ];
    size_t decryptedLength = SecKeyGetBlockSize( privateKey );
    uint8_t decrypted[ decryptedLength ];
    memset( decrypted, 0, decryptedLength );
    OSStatus status = SecKeyDecrypt( privateKey,
                                     kSecPaddingPKCS1,
                                     original_String,
                                     [ dataToDecrypt length ],
                                     decrypted,
                                     &decryptedLength
                                    );

    // NSLog( @"_RESULT_: %li", status );
    // printf( "\tDecrytpted text: %s\n***\n", decrypted );
    // Can convert to NSString from uint8_t[] if the string is NULL terminated with the following line of code:
    // NSString *strd = [ NSString stringWithUTF8String: ( char * )decrypted ];

    NSString *sDecryptedData = [ [ NSString alloc ] initWithBytes: decrypted length: decryptedLength encoding: NSUTF8StringEncoding ];
    if( privateKey )    CFRelease( privateKey );
    return sDecryptedData;
}

-( SecKeyRef )getPrivateKeyRef {
	OSStatus sanityCheck = noErr;
	SecKeyRef privateKeyReference = NULL;

	if( privateKeyRef == NULL ) {
		NSMutableDictionary * queryPrivateKey = [ [ NSMutableDictionary alloc ] init ];

		// Set the private key query dictionary.
		[ queryPrivateKey setObject: ( __bridge id )kSecClassKey forKey: ( __bridge id )kSecClass ];
		[ queryPrivateKey setObject: privateTag forKey: ( __bridge id )kSecAttrApplicationTag ];
		[ queryPrivateKey setObject: ( __bridge id )kSecAttrKeyTypeRSA forKey: ( __bridge id )kSecAttrKeyType ];
		[ queryPrivateKey setObject: [ NSNumber numberWithBool: YES ] forKey: ( __bridge id )kSecReturnRef ];

		// Get the key.
		sanityCheck = SecItemCopyMatching( ( __bridge CFDictionaryRef )queryPrivateKey, ( CFTypeRef * )&privateKeyReference );

		if( sanityCheck != noErr )
			privateKeyReference = NULL;
	} else
		privateKeyReference = privateKeyRef;

	return privateKeyReference;
}

-( SecKeyRef )getPublicKeyRef {
	OSStatus sanityCheck = noErr;
	SecKeyRef publicKeyReference = NULL;

	if( publicKeyRef == NULL ) {
		NSMutableDictionary * queryPublicKey = [ [ NSMutableDictionary alloc ] init ];

		// Set the public key query dictionary.
		[ queryPublicKey setObject: ( __bridge id )kSecClassKey forKey: ( __bridge id )kSecClass ];
		[ queryPublicKey setObject: publicTag forKey: ( __bridge id )kSecAttrApplicationTag ];
		[ queryPublicKey setObject: ( __bridge id )kSecAttrKeyTypeRSA forKey: ( __bridge id )kSecAttrKeyType ];
		[ queryPublicKey setObject: [ NSNumber numberWithBool: YES ] forKey: ( __bridge id )kSecReturnRef ];

		// Get the key.
		sanityCheck = SecItemCopyMatching( ( __bridge CFDictionaryRef )queryPublicKey, ( CFTypeRef * )&publicKeyReference );

		if( sanityCheck != noErr )
			publicKeyReference = NULL;
	} else
		publicKeyReference = publicKeyRef;

	return publicKeyReference;
}

@end
