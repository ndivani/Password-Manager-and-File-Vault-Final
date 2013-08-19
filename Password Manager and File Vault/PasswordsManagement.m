//
//  PasswordsManagement.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 02/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "PasswordsManagement.h"

@implementation PasswordsManagement

@synthesize templates_dictionary;
@synthesize passwords_dictionary;

-( id )initPasswordManagementWithTemplate: ( NSString * )sType {
    self = [  super init ];
    if( self ) {
        passwordsKeychainHandle = [ [ Keychain alloc ] init ];
        templates_dictionary = [ [ NSMutableDictionary alloc ] init ];
        passwords_dictionary = [ [ NSMutableDictionary alloc ] init ];
        sTemplateFileName = [ NSString stringWithFormat: @"%@Templates", sType ];
        sPasswordType = sType;
    }

    return self;
}

#pragma mark -
#pragma mark Template Methods.

-( void )getTemplatesFromPlist {
    // Get path for property list file.
    NSString *sPlistPathAndFile = [ self _getFilePathNameForPropertyList ];
    // Load property list data (XML) into property for calling class access to data.
    NSMutableDictionary *dictionaryFromPlist = [ NSMutableDictionary dictionaryWithContentsOfFile: sPlistPathAndFile ];
    if( dictionaryFromPlist != nil )
        templates_dictionary = [ NSMutableDictionary dictionaryWithContentsOfFile: sPlistPathAndFile ];
}

-( NSString * )_getFilePathNameForPropertyList {
    NSString *sPlistPath = [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex: 0 ];
    NSString *sPlistPathAndFile = [ sPlistPath stringByAppendingPathComponent: sTemplateFileName ];
    return sPlistPathAndFile;
}

-( BOOL )_saveTemplate: ( NSString * )sTemplateName withValues: ( NSMutableArray * )templatesValues_array {
    // If we are adding, rather than editing, we need to make sure name (ID) is not already taken.
    if( [ self _isTemplateNameUnique: sTemplateName ] )
        [ templates_dictionary setValue: templatesValues_array forKey: sTemplateName ];
    else
        return NO;

    return [ templates_dictionary writeToFile: [ self _getFilePathNameForPropertyList ] atomically: YES ];
}

-( BOOL )_isTemplateNameUnique: ( NSString * )sTemplateName {
    NSArray *namesOfExistingTemplates_array = [ templates_dictionary allKeys ];
    return ![ namesOfExistingTemplates_array containsObject: sTemplateName ];
}

-( BOOL )updateNewTemplate: ( NSString * )sNewTemplateName withNewTemplateData: ( NSMutableArray * )templateValues_array forTemplate: ( NSString * )sCurrentTemplateName {
    // if( [ sCurrentTemplateName isEqualToString: sNewTemplateName ] ) {
    if( sCurrentTemplateName != nil && ![ sCurrentTemplateName isEqualToString: @"" ] ) {
        // Must be editing (pass in blank name when adding new password) an existing (valid) password, so remove old one so we can add new one without naming (ID) conflict.
        [ templates_dictionary removeObjectForKey: sCurrentTemplateName ];
    }

    // Add new.
    return [ self _saveTemplate: sNewTemplateName withValues:templateValues_array ];
}

-( BOOL )deleteTemplate: ( NSString * )sTemplateNameToDelete {
    [ templates_dictionary removeObjectForKey: sTemplateNameToDelete ];
    return [ templates_dictionary writeToFile: [ self _getFilePathNameForPropertyList ] atomically: YES ];
}

#pragma mark -
#pragma mark Password Methods.

-( void )getPasswordsFromKeychain {

    NSData *passwordData = [ [ NSData alloc ] initWithData: [ passwordsKeychainHandle getDataFromKeychainForService: sPasswordType andAccount: @"passwords" ] ];
    NSString *errorDescription = nil;
    NSPropertyListFormat format;
    NSMutableDictionary *dictionaryFromData = [ NSPropertyListSerialization propertyListFromData: passwordData mutabilityOption: NSPropertyListMutableContainers format: &format errorDescription: &errorDescription ];
    if( dictionaryFromData != nil )
        passwords_dictionary = dictionaryFromData;
}

-( BOOL )savePassword: ( NSString * )sPasswordName withValues: ( NSMutableDictionary * )passwordValues_dictionary icon : (NSString *) iconChange {
    if( [ self _isPasswordNameUnique: sPasswordName ] ) {
        [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 1 ] forKey: @"numberOfViews_forOrdering" ];
        [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 0 ] forKey: @"numberOfTimesPasswordCopied_forOrdering" ];
        [ passwordValues_dictionary setValue: [ NSDate dateWithTimeIntervalSince1970: 0 ] forKey: @"dateLastAccessed_forOrdering" ];
        [ passwordValues_dictionary setValue:  iconChange forKey: @"imageIcon_forPassword"];
        [ passwords_dictionary setValue: passwordValues_dictionary forKey: sPasswordName ];

        NSData *passwordData = [ NSPropertyListSerialization dataWithPropertyList: passwords_dictionary
                                                                           format: NSPropertyListBinaryFormat_v1_0
                                                                          options: 0
                                                                            error: NULL ];
        if( [ passwords_dictionary count ] > 1 )
            return [ passwordsKeychainHandle updateKeychainData: passwords_dictionary forService: sPasswordType andAccount: @"passwords" ];
        else
            return [ passwordsKeychainHandle saveDataInKeychainEntryForService: sPasswordType andAccount: @"passwords" dataToSave: passwordData ];
    } else
        return NO;
}

-( BOOL )updatePassword: ( NSString * )sNewPasswordName withValues: ( NSMutableDictionary * )passwordValues_dictionary forPassword: ( NSString * )sCurrentPasswordName icon : (NSString *) iconChange{
    if( [ sNewPasswordName isEqualToString: sCurrentPasswordName ] ) {
        [ passwords_dictionary setValue: passwordValues_dictionary forKey: sCurrentPasswordName];
        [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 1 ] forKey: @"numberOfViews_forOrdering" ];
        [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 0 ] forKey: @"numberOfTimesPasswordCopied_forOrdering" ];
        [ passwordValues_dictionary setValue: [ NSDate dateWithTimeIntervalSince1970: 0 ] forKey: @"dateLastAccessed_forOrdering" ];
        [ passwordValues_dictionary setValue:  iconChange forKey: @"imageIcon_forPassword"];
        [ passwordsKeychainHandle updateKeychainData: passwords_dictionary forService: sPasswordType andAccount: @"passwords" ];
    } else {
        if( [ self _isPasswordNameUnique: sNewPasswordName ] ) {
            [ passwords_dictionary removeObjectForKey: sCurrentPasswordName ];
            [ passwords_dictionary setValue: passwordValues_dictionary forKey: sNewPasswordName];
            [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 1 ] forKey: @"numberOfViews_forOrdering" ];
            [ passwordValues_dictionary setValue: [ NSNumber numberWithInt: 0 ] forKey: @"numberOfTimesPasswordCopied_forOrdering" ];
            [ passwordValues_dictionary setValue: [ NSDate dateWithTimeIntervalSince1970: 0 ] forKey: @"dateLastAccessed_forOrdering" ];
            [ passwordValues_dictionary setValue:  iconChange forKey: @"imageIcon_forPassword"];
            [ passwordsKeychainHandle updateKeychainData: passwords_dictionary forService: sPasswordType andAccount: @"passwords" ];
        }
    }

    return YES;
}

-( BOOL )_isPasswordNameUnique: ( NSString * )sPasswordName {
    NSArray *namesOfExistingPasswords_array = [ passwords_dictionary allKeys ];
    return ![ namesOfExistingPasswords_array containsObject: sPasswordName ];
}

-( BOOL )deletePassword: ( NSString * )sPasswordNameToDelete {
    [ passwords_dictionary removeObjectForKey: sPasswordNameToDelete ];
    if( [ passwords_dictionary count ] > 0 )
        return [ passwordsKeychainHandle updateKeychainData: passwords_dictionary forService: sPasswordType andAccount: @"passwords" ];
    else
        return [ passwordsKeychainHandle deleteDataFromKeychainForService: sPasswordType andAccount: @"passwords" ];
}

@end
