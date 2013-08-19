//
//  SaveTemplate.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 08/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordsManagement.h"
#import "LabelCell.h"

@interface SaveTemplate : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIBarButtonItem *addTemplateField_btn;
    UIBarButtonItem *editTemplateFields_btn;

    NSMutableArray *rightBarButtons_array;
    PasswordsManagement *passwordDataSource;

    NSMutableArray *dataSourceForTemplateFields_array;

    Helper *helperObject;
    int iTemplateIconSelection;
}

@property( nonatomic, retain )IBOutlet UITableView *templateFields;
@property( nonatomic, retain )IBOutlet UITextField *nameOfTemplate;
@property( nonatomic, retain )IBOutlet UIBarButtonItem *addTemplateField;
@property( nonatomic, retain )NSString *sTemplateName;

-( IBAction )_saveTemplate: ( id )sender;

@end
