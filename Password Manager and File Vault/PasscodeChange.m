//
//  PasscodeChange.m
//  Password Manager and File Vault
//
//  Created by Nikhil Divani on 15/08/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "PasscodeChange.h"

@interface PasscodeChange ()

@end

@implementation PasscodeChange

@synthesize currentPasscode;
@synthesize passcodeNew;
@synthesize passcodeNewRepeat;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    passCodeMangaerSingleton = [PasscodeManager sharedPasscodeManager];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;
}

-(IBAction)setNewPasscode:(id)sender
{
    if([[currentPasscode text] isEqualToString:[passCodeMangaerSingleton getDecryptedPasscode]]){
      if([[passcodeNew text] isEqualToString:[passcodeNewRepeat text]])
      {
              [passCodeMangaerSingleton encryptPasscode];

      }
    }
}

@end
