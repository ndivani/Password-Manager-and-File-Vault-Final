//
//  Keychain.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 01/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "Keychain.h"

@implementation Keychain

-( NSData * )getDataFromKeychainForService: ( NSString * )sService andAccount: ( NSString * )sAccount {
    NSDictionary *query = @{
                            ( __bridge  id )kSecClass:          ( __bridge  id )kSecClassGenericPassword,
                            ( __bridge  id )kSecAttrService:    sService,
                            ( __bridge  id )kSecAttrAccount:    sAccount,
                            ( __bridge  id )kSecReturnData:     @YES,
                           };
    NSData *data = NULL;

    CFDictionaryRef cfquery = (__bridge_retained CFDictionaryRef)query;
    CFDictionaryRef cfresult = NULL;
    OSStatus status = SecItemCopyMatching(cfquery, (CFTypeRef *)&cfresult);
    CFRelease(cfquery);
    NSDictionary *result = (__bridge_transfer NSDictionary *)cfresult;
    NSData *keychainData = [ [ NSData alloc ] initWithData: ( NSData * )result ];

    return keychainData;
}

-( BOOL )saveDataInKeychainEntryForService: ( NSString * )sService andAccount: ( NSString * )sAccount dataToSave: ( NSData * )data {
    NSDictionary *query = @{
                            ( __bridge  id )kSecClass:          ( __bridge  id )kSecClassGenericPassword,
                            ( __bridge  id )kSecAttrService:    sService,   // Composite unique.
                            ( __bridge  id )kSecAttrAccount:    sAccount,   // Composite unique.
                            ( __bridge  id )kSecValueData:      data,
                           };

    OSStatus status = SecItemAdd( (__bridge  CFDictionaryRef )query, NULL );
    NSLog( @"\n=====\nStatus for save: %li.\n=====\n", status );
    return status == 0 ? YES : NO;
}

-( BOOL )updateKeychainData: ( NSMutableDictionary * )updatedKeychainData_dictionary forService: ( NSString * )sService andAccount: ( NSString * )sAccount {
    NSData *dataToUpdate = [ self getDataFromKeychainForService: sService andAccount: sAccount ];
    NSString *errorDescription = nil;
    NSPropertyListFormat format;
    
    NSData *updatedKeychainData = [ NSPropertyListSerialization dataWithPropertyList: updatedKeychainData_dictionary
                                                                              format: NSPropertyListBinaryFormat_v1_0
                                                                             options: 0
                                                                               error: NULL ];

    NSDictionary *changedData_dictionary = @{ ( __bridge  id )kSecValueData: updatedKeychainData, };
    NSDictionary *dataToUpdate_dictionary = @{
                                              ( __bridge  id )kSecClass:          ( __bridge  id )kSecClassGenericPassword,
                                              ( __bridge  id )kSecAttrService:    sService,   // Composite unique.
                                              ( __bridge  id )kSecAttrAccount:    sAccount,   // Composite unique.
                                              ( __bridge  id )kSecValueData:      dataToUpdate,
                                             };

    OSStatus status = SecItemUpdate( ( __bridge  CFDictionaryRef )dataToUpdate_dictionary, ( __bridge  CFDictionaryRef )changedData_dictionary );
    NSLog( @"\n=====\nStatus for update: %li.\n=====\n", status );
    return status == 0 ? YES : NO;
}

-( BOOL )deleteDataFromKeychainForService: ( NSString * )sService andAccount: ( NSString * )sAccount {
    NSDictionary *query = @{
                            ( __bridge  id )kSecClass:          ( __bridge  id )kSecClassGenericPassword,
                            ( __bridge  id )kSecAttrService:    sService,
                            ( __bridge  id )kSecAttrAccount:    sAccount,
                           };

    OSStatus status = SecItemDelete( (__bridge  CFDictionaryRef ) query );
    NSLog( @"\n=====\nStatus for delete: %li.\n=====\n", status );
    return status == 0 ? YES : NO;
}

@end
