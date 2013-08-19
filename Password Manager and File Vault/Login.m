//
//  Login.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 12/02/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "Login.h"
#define kDeleteButton           -1
#define kMaximumPasscodeDigits  4
#define kFirstDigit             0
#define kPasscode               @"0000"

@interface Login ()

@end

@implementation Login
@synthesize firstPasscodeDigit;
@synthesize secondPasscodeDigit;
@synthesize thirdPasscodeDigit;
@synthesize fourthPasscodeDigit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-( void )viewWillAppear: ( BOOL )animated {
    nextPasscodeDigitPosition = 0;
    iTotalLoginAttempts = 0;
}

-( void )viewDidAppear: ( BOOL )animated {
//    keychainObject = [ [ Keychain alloc ] init ];
//    dispatch_async(dispatch_queue_create( "uk.co.metrarc_resolve_encrypted_passcode", DISPATCH_QUEUE_CONCURRENT ), ^ {
//        [ self _resolveEncryptedPasscode ];
//    } );

    icMetrics = [ [ ICMetrics alloc ] initICMetricsWithRootViewController: self ];
    dispatch_async(dispatch_queue_create( "uk.co.metrarc_generate_key", DISPATCH_QUEUE_CONCURRENT ), ^ {
        [ icMetrics generateKey ];
    } );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   passcodeManager = [PasscodeManager sharedPasscodeManager];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-( IBAction )_populateNextDigit: ( id )sender {
    UIButton *passcodeInput_btn = ( UIButton * )sender;
    if( [ passcodeInput_btn tag ] > kDeleteButton ) {
        if( nextPasscodeDigitPosition < kMaximumPasscodeDigits ) {
            NSString *sDigit = [ NSString stringWithFormat: @"%i", [ passcodeInput_btn tag ] ];
            UITextField *textFieldToPopulate = [ self _getNextTextFieldToPopulate ];
            [ textFieldToPopulate setText: sDigit ];
            nextPasscodeDigitPosition++;
            if( nextPasscodeDigitPosition == 4 )
                [ self _attemptUserLogin ];
        }
    } else {
        if( nextPasscodeDigitPosition > kFirstDigit ) {
            nextPasscodeDigitPosition--;
            UITextField *textFieldToPopulate = [ self _getNextTextFieldToPopulate ];
            [ textFieldToPopulate setText: @"" ];
        }
    }
}

-( UITextField * )_getNextTextFieldToPopulate {
    switch( nextPasscodeDigitPosition ) {
        case 0:
            return firstPasscodeDigit;
            break;
        case 1:
            return secondPasscodeDigit;
            break;
        case 2:
            return thirdPasscodeDigit;
            break;
        case 3:
            return fourthPasscodeDigit;
            break;
        default:
            return nil;
    }
}

-( void )_attemptUserLogin {
    iTotalLoginAttempts++;
    UIStoryboard *storyboard = [ self storyboard ];
    if( [ [ self _getPasscodeValue ] isEqualToString:[passcodeManager getDecryptedPasscode] ] )
        [ self presentViewController: [ storyboard instantiateViewControllerWithIdentifier: @"appstart" ] animated: YES completion: nil ];
    else {
        UIAlertView *loginFailAlert = [ [ UIAlertView alloc ] initWithTitle: @"Login failed." message: [ NSString stringWithFormat: @"Passcode entered is not valid. %i failed login attempt(s).", iTotalLoginAttempts ] delegate: nil cancelButtonTitle: @"Understood" otherButtonTitles: nil ];
        [ loginFailAlert show ];
    }
}

-( NSString * )_getPasscodeValue {
    NSString *sPasscodeAsString = [ [ NSString alloc ] initWithFormat: @"%@%@%@%@", [ firstPasscodeDigit text ], [ secondPasscodeDigit text ], [ thirdPasscodeDigit text ], [ fourthPasscodeDigit text ] ];
    return sPasscodeAsString;
}

//-( void )_resolveEncryptedPasscode {
//    // Get encrypted passcode from keychain.
//    NSData *encryptedPasscode_data = [ [ NSData alloc ] initWithData: [ keychainObject getDataFromKeychainForService: @"passcode" andAccount: @"login" ] ];
//
//    // Decrypt the passcode taken from the keychain.
//    AsymmetricEncryptionRSA *asymmetricEncryptionRsa = [ [ AsymmetricEncryptionRSA alloc ] init ];
//    [ asymmetricEncryptionRsa generateKeyPair ];
//    sDecryptedPasscode = [ asymmetricEncryptionRsa decryptWithPrivateKey: encryptedPasscode_data ];
//    NSLog( @"%@", sDecryptedPasscode );
//    encryptedPasscode_data = nil;
//}
//
-( IBAction )_setPasscode: ( id )sender {
    [ passcodeManager  encryptPasscode ];
}
//
//-( NSData * )encryptPasscode {
//    AsymmetricEncryptionRSA *asymmetricEncryptionRSA = [ [ AsymmetricEncryptionRSA alloc ] init ];
//    [ asymmetricEncryptionRSA generateKeyPair ];
//    NSData *rsaEncryptedData = [ [ NSData alloc ] initWithData: [ asymmetricEncryptionRSA encryptWithPublicKey: kPasscode ] ];
//    keychainObject = [ [ Keychain alloc ] init ];
//    [ keychainObject saveDataInKeychainEntryForService: @"passcode" andAccount: @"login" dataToSave: rsaEncryptedData ];
//    keychainObject = nil;
//    return rsaEncryptedData;
//}

@end
