//
//  PasswordsManagementTests.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 03/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "PasswordsManagementTests.h"

@implementation PasswordsManagementTests

-( void )setUp {
    [ super setUp ];
    managePasswords = [ [ PasswordsManagement alloc ] initPasswordManagementWithTemplate: @"login" ];
    STAssertNotNil( managePasswords, @"Could not create object to test." );
}

-( void )tearDown {
    [ super tearDown ];
}

#pragma mark -
#pragma mark Template tests

-( void )testWriteToTemplatePlist {
    NSMutableArray *templateData_array = [ [ NSMutableArray alloc ] initWithObjects: @"username", @"password", nil ];
    [ managePasswords updateNewTemplate: @"template1" withNewTemplateData: templateData_array forTemplate: @"" ];
    [ self _readTemplatePlist: 1 ];
}

-( void )_readTemplatePlist: ( int )iExpectedValue {
    // Read file to check for any changes to template collection before seeing if action was successful.
    [ managePasswords getTemplatesFromPlist ];
    STAssertTrue( [ managePasswords.templates_dictionary count ] == iExpectedValue, @"Failed to update template collection." );
}

-( void )testWriteToTemplatePlistInvalidValue {
    [ self testWriteToTemplatePlist ];
}

-( void )testUpdateTemplatePlist {
    NSMutableArray *templateData_array = [ [ NSMutableArray alloc ] initWithObjects: @"username", @"password", @"email", nil ];
    [ managePasswords updateNewTemplate: @"template1" withNewTemplateData: templateData_array forTemplate: @"template1" ];
    [ self _readTemplatePlist: 1 ];
}

-( void )testDeleteFromTemplatePlist {
    [ managePasswords deleteTemplate: @"template1" ];
    [ self _readTemplatePlist: 0 ];
}

#pragma mark -
#pragma mark Password tests

-( void )testSaveNewPassword {
    NSMutableDictionary *passwordValues_dictionary = [ [ NSMutableDictionary alloc ] init ];
    [ passwordValues_dictionary setValue: @"chris@metrarc.com" forKey: @"username" ];
    [ passwordValues_dictionary setValue: @"MeTrArC@20" forKey: @"password" ];
    [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 1 ] forKey: @"NumberOfViews" ];
    [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 0 ] forKey: @"NumberOfTimesPasswordCopied" ];
    [ passwordValues_dictionary setValue: [ NSDate dateWithTimeIntervalSince1970: 0 ]  forKey: @"DateLastAccessed" ];

    [ managePasswords savePassword: @"password1" withValues: passwordValues_dictionary ];
    [ self _readPasswordsFromKeychain: 1 ];
}

-( void )_readPasswordsFromKeychain: ( int )iExpectedValue {
    [ managePasswords getPasswordsFromKeychain ];
    STAssertTrue( [ managePasswords.passwords_dictionary count ] == iExpectedValue, @"Failed to update template collection." );
}

-( void )testSaveInvalidPassword {
    [ self testSaveNewPassword ];
}

-( void )testUpdatePassword {
    [ managePasswords getPasswordsFromKeychain ];
    NSMutableDictionary *passwordValues_dictionary = [ [ NSMutableDictionary alloc ] initWithDictionary: managePasswords.passwords_dictionary ];
    NSMutableDictionary *passwordToUpdate_dictionary = [ [ NSMutableDictionary alloc ] initWithDictionary: [ passwordValues_dictionary objectForKey: @"password1" ] ];
    [ passwordToUpdate_dictionary setValue: @"chris@metrarc.co.uk" forKey: @"username" ];

    [ managePasswords updatePassword: @"password1" withValues: passwordToUpdate_dictionary forPassword: @"password1" ];
    [ managePasswords getPasswordsFromKeychain ];
    NSMutableDictionary *passwordData_dictionary = [ managePasswords.passwords_dictionary objectForKey: @"password1" ];
    NSString *sUsername = [ passwordData_dictionary objectForKey: @"username" ];
    NSString *sPassword = [ passwordData_dictionary objectForKey: @"password" ];
    STAssertTrue( ( [ sUsername isEqualToString: @"chris@metrarc.co.uk" ] && [ sPassword isEqualToString: @"MeTrArC@20" ] ), @"Failed to update password data." );
}

-( void )testDeletePasswordFromKeychain {
    [ managePasswords deletePassword: @"password1" ];
    [ self _readPasswordsFromKeychain: 0 ];
}

@end
