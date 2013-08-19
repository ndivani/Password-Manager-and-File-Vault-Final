//
//  Login.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 12/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsymmetricEncryptionRSA.h"
#import "GetFeatures.h"
#import "Keychain.h"
#import "ICMetrics.h"
#import "PasscodeManager.h"

@interface Login : UIViewController {
    UITextField *firstPasscodeDigit;
    UITextField *secondPasscodeDigit;
    UITextField *thirdPasscodeDigit;
    UITextField *fourthPasscodeDigit;

    int nextPasscodeDigitPosition;
    int iTotalLoginAttempts;

    DBRestClient *restClient;
    GetFeatures *getFeatures;
    Keychain *keychainObject;
    ICMetrics *icMetrics;
    PasscodeManager *passcodeManager;
    
    NSString *sDecryptedPasscode;
}

@property( nonatomic, retain )IBOutlet UITextField *firstPasscodeDigit;
@property( nonatomic, retain )IBOutlet UITextField *secondPasscodeDigit;
@property( nonatomic, retain )IBOutlet UITextField *thirdPasscodeDigit;
@property( nonatomic, retain )IBOutlet UITextField *fourthPasscodeDigit;

-( IBAction )_populateNextDigit: ( id )sender;
-( UITextField * )_getNextTextFieldToPopulate;
-( IBAction )_setPasscode: ( id )sender;

@end
