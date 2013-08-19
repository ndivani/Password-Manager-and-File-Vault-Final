//
//  ViewTemplates.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 08/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordsManagement.h"
#import "SaveTemplate.h"
#import "SavePassword.h"

@interface ViewTemplates : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    PasswordsManagement *passwordsDataSource;
    NSMutableArray *templates_array;
    NSString *sTemplateName;
    int iPickerRowSelected;

    SaveTemplate *templateView;
}

@property( nonatomic, retain )IBOutlet UIPickerView *templates;

-( IBAction )_createPassword: ( id )sender;
-( IBAction )_deleteTemplate: ( id )sender;
-( IBAction )_createTemplate: ( id )sender;
-( IBAction )_editTemplate: ( id )sender;

@end
