//
//  SavePassword.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 04/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelAndValueCell.h"
#import "PasswordsManagement.h"
#import "IconSelect.h"


@interface SavePassword : UIViewController <SecondDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIBarButtonItem *addPasswordField_btn;
    UIBarButtonItem *editPasswordFields_btn;
    UIBarButtonItem *editBtn;

    NSMutableArray *rightBarButtons_array;

    NSMutableArray *dataSourceForPasswordLabels_array;
    NSMutableArray *dataSourceForPasswordValues_array;

    PasswordsManagement *passwordDataSource;
    NSMutableDictionary *passwordFields_dictionary;

    Helper *helperObject;
}

@property( nonatomic, retain )IBOutlet UITableView *passwordFields;
@property( nonatomic, retain )IBOutlet UITextField *passwordName;
@property( nonatomic, retain )IBOutlet UIBarButtonItem *addPasswordField;

@property ( nonatomic, retain) NSString *iconImagePath;

@property( nonatomic, retain )NSString *sPasswordName;
@property( nonatomic, retain )NSString *sTemplateName;

@property( nonatomic, retain )IBOutlet UIImageView *passwordIcon;

@property(nonatomic, retain) IBOutlet UIButton *changeIconButton;

-( IBAction )_editPasswordFields: ( id )sender;
-( IBAction )_addPasswordField: ( id )sender;
-( IBAction )_savePassword: ( id )sender;

-(IBAction)_changeIconButton:(id)sender;

@end
