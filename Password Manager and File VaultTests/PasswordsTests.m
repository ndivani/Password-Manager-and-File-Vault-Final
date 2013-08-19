//
//  PasswordsTests.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 10/04/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "PasswordsTests.h"

@implementation PasswordsTests
/*
-( void )setUp {
    [ super setUp ];
    passwordsTestObj = [ [ Passwords alloc ] initWithTemplateFileName: @"" fileNameForPasswords: @"" andFileNameForFolders: @"" ];
    STAssertNotNil( passwordsTestObj, @"Could not create test subject." );
}

-( void )tearDown {
    [ super tearDown ];
}

#pragma mark -
#pragma mark Test methods for initialising objects to represent app data.

-( void )testTemplatesDictInit {
    // Check the when we init our object, we get all the template data from the property list.
    STAssertTrue( [ passwordsTestObj.passwordTemplates_dict count ] == kNumberOfTemplatesOnInit, @"Failed to initalise template dictionary." );
}

-( void )testPasswordsDictInit {
    // Call the method we created to return how many passwords we have saved in our app data.
    [ self checkPasswordDataForOverallDataCount: kNumberOfPasswordsOnInit ];
}

-( void )testFoldersDictInit {
    // Check the when we init our object, we get all the folder data from the property list.
    STAssertTrue( [ passwordsTestObj.folders_array count ] == kNumberOfFoldersOnInit, @"Failed to initalise folder dictionary." );
}

#pragma mark -
#pragma mark Test methods for creating new app data.

-( void )testCreateTemplateWithValidName {
    // Init a test to test a template can be created when using a valid name.
    [ self addTemplateNamed: @"templateName" toIncreaseTemplateCountTo: kNumberOfTemplatesOnInit + 1 ];
}

-( void )testCreateTemplateWithInvalidName {
    // Init a test to test a template will not be created when using an invalid name.
    [ self addTemplateNamed: @"email" toIncreaseTemplateCountTo: kNumberOfTemplatesOnInit ];
}

// This method takes a template name to create, gives it some arbitary fields, calls the Password object's
// method to attempt to add the new template before checking to see if the result was as expected.
-( void )addTemplateNamed: ( NSString * )sTemplateName toIncreaseTemplateCountTo: ( NSUInteger )iExpectedTemplateCount {
    // Create the template data.
    NSMutableArray *templateFields_array = [ [ NSMutableArray alloc ] init ];
    [ templateFields_array addObject: sTemplateName ];
    [ templateFields_array  addObject: @"username" ];
    [ templateFields_array  addObject: @"password" ];
    [ templateFields_array  addObject: @"telephone" ];

    // Call the Password class method we want to test.
    [ passwordsTestObj createNewTemplate: sTemplateName withData: templateFields_array ];

    // Check the result is what we expect.
    STAssertTrue( [ passwordsTestObj.passwordTemplates_dict count ] == iExpectedTemplateCount, @"Create template method resulted in unexpected behaviour." );
}

-( void )testCreatePasswordWithValidName {
    // Init a test to test a password can be created when using a valid name.
    [ self addPasswordNamed: @"newEmail" toIncreasePasswordCountTo: kNumberOfPasswordsOnInit + 1 ];
}

-( void )testCreatePasswordWithInvalidName {
    // Init a test to test a password will not be created when using an invalid name.
    [ self addPasswordNamed: @"miloGmail" toIncreasePasswordCountTo: kNumberOfPasswordsOnInit ];
}

// This method takes a password name to create, gives it some arbitary fields, calls the Password object's
// method to attempt to add the new password before checking to see if the result was as expected.
-( void )addPasswordNamed: ( NSString * )sPasswordName toIncreasePasswordCountTo: ( NSUInteger )iExpectedPasswordCount {
    // Create the password we are going to save.
    NSMutableDictionary *passwordToSave_dict = [ [ NSMutableDictionary alloc ] init ];
    [ passwordToSave_dict setValue: @"un" forKey: @"un" ];
    [ passwordToSave_dict setValue: @"pw" forKey: @"pw" ];
    [ passwordToSave_dict setValue: [ NSNumber numberWithInt: 1 ] forKey: @"NumberOfViews" ];
    [ passwordToSave_dict setValue: [ NSNumber numberWithInt: 0 ] forKey: @"NumberOfTimesPasswordCopied" ];
    [ passwordToSave_dict setValue: [ NSDate dateWithTimeIntervalSince1970: 0 ]  forKey: @"DateLastAccessed" ];

    // Call the Password class method we want to test.
    [ passwordsTestObj savePassword: sPasswordName withData: passwordToSave_dict withIdentifier: @"" inCategory: @"email" isPasswordStateEdit: NO ];

    // Call the method that will check the result is what we expect.
    [ self checkPasswordDataForOverallDataCount: iExpectedPasswordCount ];
}

-( void )testCreateFolderWithValidName {
    // Init a test to test a folder can be created when using a valid name.
    [ passwordsTestObj createFolderNamed: @"newFolder4" ];
    STAssertTrue( [ passwordsTestObj.folders_array count ] == kNumberOfFoldersOnInit + 1, @"Create folder method resulted in unexpected behaviour." );
}

-( void )testCreateFolderWithInvalidName {
    // Init a test to test a folder can be created when using an invalid name.
    [ passwordsTestObj createFolderNamed: @"folder2" ];
    STAssertTrue( [ passwordsTestObj.folders_array count ] == kNumberOfFoldersOnInit, @"Create folder method resulted in unexpected behaviour." );
}

#pragma mark -
#pragma mark Test methods for editing app data.

// Changing template identifier is different to an arbitary field, as it requires appropriate password data to get updated.
-( void )testEditTemplateIdentifier {
    // Create a new template name, and define existing template name to change.
    NSString *sNewTemplateIdentifier = @"newTemplateName";
    NSString *sExistingTemplateIdentifier = @"google";
    // Create some template fields to use.
    NSMutableArray *googleTemplate_array = [ [ NSMutableArray alloc ] initWithObjects: @"username", @"password", @"account number", nil ];

    // Call Passwords object method we are testing.
    [ passwordsTestObj updateTemplate: sNewTemplateIdentifier forTemplateData: googleTemplate_array currentTemplateIdentifier: sExistingTemplateIdentifier ];

    // Test to make sure we changed name & data passed across correctly.
    NSMutableArray *fieldsForDeletedTemplate_array = [ passwordsTestObj.passwordTemplates_dict objectForKey: @"google" ];
    NSMutableArray *fieldsForNewTemplate_array = [ passwordsTestObj.passwordTemplates_dict objectForKey: @"newTemplateName" ];
    STAssertTrue( ( ( fieldsForDeletedTemplate_array == nil  ) && ( [ fieldsForNewTemplate_array count ] == kNumberOfTemplateFieldsOnInit + 1 ) ), @"Err." );

    // Test to make sure any passwords associated with the template that changed got updated correctly.
    NSMutableArray *passwordsForDeletedTemplate_array = [ passwordsTestObj.passwords_dict objectForKey: @"google" ];
    NSMutableArray *passwordsForNewTemplate_array = [ passwordsTestObj.passwords_dict objectForKey: @"newTemplateName" ];
    STAssertTrue( ( ( passwordsForDeletedTemplate_array == nil  ) && ( [ passwordsForNewTemplate_array count ] == kNumberOfPasswordsAssociatedWithNewTemplateOnInit + 1 ) ), @"Err." );
}

-( void )testEditTemplateFields {
    // Create a new template name, and define existing template name to change.
    NSString *sNewTemplateIdentifier = @"google";
    NSString *sExistingTemplateIdentifier = @"google";
    // Create some template fields to use.
    NSMutableArray *googleTemplate_array = [ [ NSMutableArray alloc ] initWithObjects: @"username", @"password", @"account number", nil ];

    // Call Passwords object method we are testing.
    [ passwordsTestObj updateTemplate: sNewTemplateIdentifier forTemplateData: googleTemplate_array currentTemplateIdentifier: sExistingTemplateIdentifier ];

    // Test to make sure we changed name & data passed across correctly.
    NSMutableArray *fieldsForEditedTemplate = [ passwordsTestObj.passwordTemplates_dict objectForKey: @"google" ];
    STAssertTrue( [ fieldsForEditedTemplate count ] == kNumberOfTemplateFieldsOnInit, @"Failed to edit template field." );
}

-( void )testEditPassword {
    // Create new password identifier, and define existing password identifier.
    NSString *sNewPasswordIdentifier = @"newMiloGmail";
    NSString *sExistingPasswordIdentifier = @"miloGmail";

    // Create some new password data to use.
    NSMutableDictionary *newMiloGmail = [ [ NSMutableDictionary alloc ] init ];
    [ newMiloGmail setValue: @"un" forKey: @"un" ];
    [ newMiloGmail setValue: @"pw" forKey: @"pw" ];
    [ newMiloGmail setValue: @"newFieldValue" forKey: @"newField" ];
    [ newMiloGmail setValue: [ NSNumber numberWithInt: 2 ] forKey: @"NumberOfViews" ];
    [ newMiloGmail setValue: [ NSNumber numberWithInt: 1 ] forKey: @"NumberOfTimesPasswordCopied" ];
    [ newMiloGmail setValue: [ NSDate date ] forKey: @"DateLastAccessed" ];

    // Call Passwords object method we are testing.
    [ passwordsTestObj savePassword: sNewPasswordIdentifier withData: newMiloGmail withIdentifier: sExistingPasswordIdentifier inCategory: @"email" isPasswordStateEdit: YES ];

    // Test to make sure the password data changed as expected.
    NSMutableDictionary *passwordForEmailType = [ passwordsTestObj.passwords_dict objectForKey: @"email" ];
    NSMutableDictionary *deletedPassword_dict = [ passwordForEmailType objectForKey: sExistingPasswordIdentifier ];
    NSMutableDictionary *newEditedPassword_dict = [ passwordForEmailType objectForKey: sNewPasswordIdentifier ];
    STAssertTrue( ( deletedPassword_dict == nil && [ newEditedPassword_dict count ] == kNumberOfFieldsInEmailOnInit + 1 ), @"Failed to edit password." );
}

-( void )testEditFolder {
    // Get the current name of the folder to re-name, and init the new name.
    NSString *sCurrentFolderName = @"folder2";
    NSString *sNewFolderName = @"newFolder2";

    // Call Passwords object method we are testing.
    [ passwordsTestObj renameFolderFrom: sCurrentFolderName toNewFolderName: sNewFolderName ];

    // Test to make sure the folder was renamed correctly.
    NSMutableArray * sExistingFolderNames_array = passwordsTestObj.folders_array;
    STAssertTrue( ( ![ sExistingFolderNames_array containsObject: sCurrentFolderName ] && [ sExistingFolderNames_array containsObject: sNewFolderName ] ), @"Folder not re-named." );
}

#pragma mark -
#pragma mark - Test methods for deleting app data.

-( void )testDeleteTemplate {
    // Test we can remove the google template.
    NSString *sTemplateIdentifierToDelete = @"google";
    [ passwordsTestObj deleteTemplate: sTemplateIdentifierToDelete ];
    STAssertTrue( [ passwordsTestObj.passwordTemplates_dict count ] == kNumberOfTemplatesOnInit - 1, @"Failed to delete template." );
}

-( void )testDeletePassword {
    NSString *sPasswordIdentifierToDelete = @"miloGmail";
    NSString *sCategoryOfPasswordToDelete = @"email";

    // Call method we are testing.
    [ passwordsTestObj deletePassword: sPasswordIdentifierToDelete inCategory: sCategoryOfPasswordToDelete ];

    // Test password has been deleted.
    [ self checkPasswordDataForOverallDataCount: kNumberOfPasswordsOnInit - 1 ];
}

-( void )testDeleteFolder {
    // Test we can delete the 'folder2' folder.
    NSString *sFolderNameToDelete = @"folder2";
    [ passwordsTestObj deleteFolderNamed: sFolderNameToDelete ];
    STAssertTrue( [ passwordsTestObj.folders_array count ] == kNumberOfFoldersOnInit - 1, @"Failed to delete folder." );
}

#pragma mark -
#pragma mark Test methods for moving app data.

-( void )testMovingPassword {
    // Declare the current template location, and the folder we are going to try moving the password to.
    NSString *sCurrentTemplateLocation = @"email";
    NSString *sFolderLocationToMovePasswordTo = @"folder2";
    NSString *sPasswordIdentifier = @"miloGmail";

    [ passwordsTestObj updatePasswordType: sCurrentTemplateLocation toNewType: sFolderLocationToMovePasswordTo ];

    // Get the passwords for the two locations, so we can check that the password has moved correctly.
    NSMutableDictionary *passwordsForOldLocation_dict = [ passwordsTestObj.passwords_dict objectForKey: sCurrentTemplateLocation ];
    NSMutableDictionary *passwordsForNewLocation_dict = [ passwordsTestObj.passwords_dict objectForKey: sFolderLocationToMovePasswordTo ];

    STAssertTrue( ( [ passwordsForOldLocation_dict objectForKey: sPasswordIdentifier ] == nil && [ passwordsForNewLocation_dict objectForKey: sPasswordIdentifier ] != nil ), @"Failed to move password." );
}

#pragma mark -

// This method counts the total passwords found in the app data. It then checks this value against the expected value.
-( void )checkPasswordDataForOverallDataCount: ( NSUInteger )iTotalPasswordsExpected {
    NSUInteger iTotalPasswordsFound = 0;
    NSMutableDictionary *nextPasswordCat_dict;
    // Need to get all categories of passwords that are stored in the app.
    NSArray *storedPasswordCats = [ passwordsTestObj.passwords_dict allKeys ];
    for( NSString *sNextPasswordCat in storedPasswordCats ) {
        // For each category that has passwords stored, we get the total passwords for each category, and add it to the running total.
        nextPasswordCat_dict = [ passwordsTestObj.passwords_dict objectForKey: sNextPasswordCat ];
        iTotalPasswordsFound += [ nextPasswordCat_dict count ];
    }

    // Check the total passwords found is what was expected.
    STAssertTrue( iTotalPasswordsFound == iTotalPasswordsExpected, @"Unexpected amount of passwords found." );
}
*/
@end
