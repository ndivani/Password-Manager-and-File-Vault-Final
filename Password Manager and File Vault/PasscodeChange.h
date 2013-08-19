//
//  PasscodeChange.h
//  Password Manager and File Vault
//
//  Created by Nikhil Divani on 15/08/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasscodeManager.h"    

@interface PasscodeChange : UIViewController
{
    PasscodeManager *passCodeMangaerSingleton;
   
}

@property(nonatomic,retain) IBOutlet UITextField *currentPasscode;
@property(nonatomic,retain) IBOutlet UITextField *passcodeNew;
@property(nonatomic,retain) IBOutlet UITextField *passcodeNewRepeat;

-(IBAction)setNewPasscode:(id)sender;

@end
