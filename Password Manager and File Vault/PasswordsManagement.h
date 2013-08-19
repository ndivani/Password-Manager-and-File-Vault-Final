//
//  PasswordsManagement.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 02/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keychain.h"

@interface PasswordsManagement : NSObject {
    NSString *sTemplateFileName;
    NSString *sPasswordType;
    NSMutableDictionary *templates_dictionary;

    Keychain *passwordsKeychainHandle;
    NSMutableDictionary *passwords_dictionary;
}

@property( nonatomic, retain )NSMutableDictionary *templates_dictionary;
@property( nonatomic, retain )NSMutableDictionary *passwords_dictionary;

-( id )initPasswordManagementWithTemplate: ( NSString * )sType;
-( void )getTemplatesFromPlist;
-( BOOL )updateNewTemplate: ( NSString * )sNewTemplateName withNewTemplateData: ( NSMutableArray * )templateValues_array forTemplate: ( NSString * )sCurrentTemplateName;
-( BOOL )deleteTemplate: ( NSString * )sTemplateNameToDelete;

-( void )getPasswordsFromKeychain;
-( BOOL )savePassword: ( NSString * )sPasswordName withValues: ( NSMutableDictionary * )passwordValues_dictionary icon: (NSString *) iconChange;
-( BOOL )updatePassword: ( NSString * )sNewPasswordName withValues: ( NSMutableDictionary * )passwordValues_dictionary forPassword: ( NSString * )sCurrentPasswordName icon: (NSString *) iconChange;
-( BOOL )deletePassword: ( NSString * )sPasswordNameToDelete;

@end
