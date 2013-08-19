//
//  Keychain.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 01/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

-( NSData * )getDataFromKeychainForService: ( NSString * )sService andAccount: ( NSString * )sAccount;
-( BOOL )saveDataInKeychainEntryForService: ( NSString * )sService andAccount: ( NSString * )sAccount dataToSave: ( NSData * )data;
-( BOOL )updateKeychainData: ( NSMutableDictionary * )updatedKeychainData forService: ( NSString * )sService andAccount: ( NSString * )sAccount;
-( BOOL )deleteDataFromKeychainForService: ( NSString * )sService andAccount: ( NSString * )sAccount;

@end
