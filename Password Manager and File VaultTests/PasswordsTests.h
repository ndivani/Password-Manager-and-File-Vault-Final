//
//  PasswordsTests.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 10/04/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//  Author Milo.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Passwords.h"

#define kNumberOfTemplatesOnInit                            3
#define kNumberOfPasswordsOnInit                            3
#define kNumberOfFoldersOnInit                              3
#define kNumberOfTemplateFieldsOnInit                       2
#define kNumberOfPasswordsAssociatedWithNewTemplateOnInit   0
#define kNumberOfPasswordsAssociatedWithEmailTemplateOnInit 2
#define kNumberOfPasswordsAssociatedWithFolder2OnInit       0
#define kNumberOfFieldsInEmailOnInit                        5

@interface PasswordsTests : SenTestCase {
    Passwords *passwordsTestObj;
}

@end