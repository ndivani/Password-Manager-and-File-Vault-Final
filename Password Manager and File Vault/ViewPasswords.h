//
//  ViewPasswords.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 08/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordsManagement.h"
#import "SavePassword.h"
#import "PasswordViewCell.h"

@interface ViewPasswords : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    PasswordsManagement *pm;
    NSString *sPasswordType;
    NSMutableArray *passwordNames_array;
    NSMutableArray *passwordIcons_array;

    UIBarButtonItem *delPasswords_btn;

    Helper *helperObject;
}

@property( nonatomic, retain )IBOutlet UITableView *passwords;

@end
