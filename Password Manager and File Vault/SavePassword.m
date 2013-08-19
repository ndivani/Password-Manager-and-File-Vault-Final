//
//  SavePassword.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 04/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "SavePassword.h"

@interface SavePassword ()

@end

@implementation SavePassword

@synthesize passwordFields;
@synthesize passwordName;
@synthesize addPasswordField;

@synthesize sPasswordName;
@synthesize sTemplateName;

@synthesize passwordIcon;

@synthesize iconImagePath;

@synthesize changeIconButton;

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
	// Do any additional setup after loading the view.
}

-( void )viewWillAppear: ( BOOL )animated {
    if (!iconImagePath) {
        iconImagePath = @"_";
    }
    editPasswordFields_btn = [ [ UIBarButtonItem alloc ] initWithTitle: @"Edit"
                                                                 style: UIBarButtonItemStyleBordered
                                                                target: self
                                                                action: @selector( _editPasswordFields: ) ];

    addPasswordField_btn = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                                                            target: self
                                                                            action: @selector( _addPasswordField: ) ];

    rightBarButtons_array = [ [ NSMutableArray alloc ] initWithObjects: editPasswordFields_btn, nil ];
    self.navigationItem.rightBarButtonItems = rightBarButtons_array;

    dataSourceForPasswordLabels_array = [ [ NSMutableArray alloc ] init ];
    dataSourceForPasswordValues_array = [ [ NSMutableArray alloc ] init ];

    helperObject = [ [ Helper alloc ] init ];
    NSUInteger tabSelected = [ self.tabBarController selectedIndex ];
    NSString *sPasswordType = [ helperObject determinePasswordTypeFromTab: tabSelected ];

    passwordDataSource = [ [ PasswordsManagement alloc ] initPasswordManagementWithTemplate: sPasswordType ];
    [ passwordDataSource getPasswordsFromKeychain ];
    
    
    // Init datasource (array) from NSDictionary property that can be pre-filled prior to screen loading for edit.
    if( sPasswordName != nil && ![ sPasswordName isEqualToString: @"" ] ) {
        // Edit password.
        [ passwordName setText: sPasswordName ];

        passwordFields_dictionary = [ [ NSMutableDictionary alloc ] initWithDictionary: [ passwordDataSource.passwords_dictionary objectForKey: sPasswordName ] ];
        // Ignore fields for functions like ordering passwords.
        if( [ [ passwordFields_dictionary allKeys ] count ] < 5 || [ self _isPasswordFieldsOnlySortFuncAndIcon ] ) {
            [ dataSourceForPasswordLabels_array addObject: @"" ];
            [ dataSourceForPasswordValues_array addObject: @"" ];
        } else {
            for( NSString *sKey in [ passwordFields_dictionary allKeys ] ) {
                if( ![ sKey isEqualToString: @"numberOfViews_forOrdering" ] && ![ sKey isEqualToString: @"numberOfTimesPasswordCopied_forOrdering" ] && ![ sKey isEqualToString: @"dateLastAccessed_forOrdering" ] && ![ sKey isEqualToString: @"imageIcon_forPassword" ]) {
                    [ dataSourceForPasswordLabels_array addObject: sKey ];
                    [ dataSourceForPasswordValues_array addObject: [ passwordFields_dictionary objectForKey: sKey ] ];
                }
                
                
                if ([ sKey isEqualToString: @"imageIcon_forPassword" ]) {
                    if ([iconImagePath isEqual: @"_"]) {
                        if ([passwordFields_dictionary objectForKey:sKey])
                            iconImagePath = [passwordFields_dictionary objectForKey:sKey];
                        else
                            iconImagePath = @" ";
                    }
                }
            }
        }
    } else {
        
#pragma mark need to add in iconImages to the dictionary for a new password when creating from template
        
        // New password.
        passwordFields_dictionary = [ [ NSMutableDictionary alloc ] init ];
        [ passwordDataSource getTemplatesFromPlist ];
        // Handle using a template with no fields to create a new password.
        if( [ [ passwordDataSource.templates_dictionary objectForKey: sTemplateName  ] count ] == 0 ) {
            [ dataSourceForPasswordLabels_array addObject: @"" ];
            [ dataSourceForPasswordValues_array addObject: @"" ];
        } else {
            for( NSString *sPasswordLabel in [ passwordDataSource.templates_dictionary objectForKey: sTemplateName  ] ) {
                [ dataSourceForPasswordLabels_array addObject: sPasswordLabel ];
                [ dataSourceForPasswordValues_array addObject: @"" ];
            }
        }
    }

    [ passwordName addTarget: self
                      action: @selector( _dismissKeyboard: )
            forControlEvents: UIControlEventEditingDidEndOnExit ];
    
    // updates the current icon with the icon stored in the "password"
#pragma mark re-add this code
    //NSLog(iconImagePath);
    passwordIcon.image = [UIImage imageNamed:iconImagePath];
    
    changeIconButton.hidden = YES;
    
}

-( BOOL )_isPasswordFieldsOnlySortFuncAndIcon {
    if( [ [ passwordFields_dictionary allKeys ] count ] == 4 ) {
        // Check if fields are 3 sorting funcs + icon.
    }

    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Datasource Methods

-( NSInteger )numberOfSectionsInTableView: ( UITableView * )tableView {
    return 1;
}

-( NSInteger )tableView: ( UITableView * )tableView numberOfRowsInSection: ( NSInteger )section {
    return [ dataSourceForPasswordLabels_array count ] > 0 ? [ dataSourceForPasswordLabels_array count ] : 1;
}

-( UITableViewCell * )tableView: ( UITableView * )tableView cellForRowAtIndexPath: ( NSIndexPath * )indexPath {
    LabelAndValueCell *tableViewCell = ( LabelAndValueCell * )[ tableView dequeueReusableCellWithIdentifier: @"LabelAndValue" ];
    if( tableViewCell == nil ) {
        tableViewCell = [ [ LabelAndValueCell alloc ] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"LabelAndValue" ];
    }

    // Set UITextField delegate methods for when text changes.
    [ tableViewCell.fieldLabel addTarget: self
                                  action: @selector( _updatePasswordLabelForPasswordField: )
                        forControlEvents: UIControlEventEditingDidEndOnExit ];

    [ tableViewCell.fieldLabel addTarget: self
                                  action: @selector( _updatePasswordLabelForPasswordField: )
                        forControlEvents: UIControlEventEditingDidEnd ];

    [ tableViewCell.fieldLabel setTag: [ indexPath row ] ];
    [ tableViewCell.fieldLabel setText: [ dataSourceForPasswordLabels_array objectAtIndex: [ indexPath row ] ] ];

    [ tableViewCell.fieldValue addTarget: self
                                  action: @selector( _updatePasswordValueForPasswordField: )
                        forControlEvents: UIControlEventEditingDidEndOnExit ];
    [ tableViewCell.fieldValue setTag: [ indexPath row ] ];

    [ tableViewCell.fieldValue addTarget: self
                                  action: @selector( _updatePasswordValueForPasswordField: )
                        forControlEvents: UIControlEventEditingDidEnd ];
    [ tableViewCell.fieldValue setTag: [ indexPath row ] ];
    [ tableViewCell.fieldValue setText: [ dataSourceForPasswordValues_array objectAtIndex: [ indexPath row ] ] ];

    return tableViewCell;
}

-( BOOL )tableView: ( UITableView * )tableView canEditRowAtIndexPath: ( NSIndexPath * )indexPath {
    return YES;
}

-( BOOL )tableView: ( UITableView * )tableView canMoveRowAtIndexPath: ( NSIndexPath * )indexPath {
    return NO;
}

#pragma mark - stop it showing the delete icon when array size is 1
#pragma mark UITableView Delegate Methods

-( void )tableView: ( UITableView * )tableView commitEditingStyle: ( UITableViewCellEditingStyle )editingStyle forRowAtIndexPath: ( NSIndexPath * )indexPath {
    if ([dataSourceForPasswordLabels_array count] >1) {
        NSInteger iRowDeleted = [ indexPath row ];
        [ dataSourceForPasswordLabels_array removeObjectAtIndex: iRowDeleted ];
        [ dataSourceForPasswordValues_array removeObjectAtIndex: iRowDeleted ];
        [ passwordFields reloadData ];
    }
}

#pragma mark method for secondDelegate of iconSelect //elliott
- (void)iconSelectDismissed:(NSString *)stringForFirst
{
    iconImagePath = stringForFirst;
    
    //handles the edit phase back to not editing, the state it was in when entering the iconSelect state
    [ passwordFields setEditing: ![ passwordFields isEditing ] ];
}

#pragma mark -
#pragma mark Methods For When UI Buttons For UITableView Clicked

-( IBAction )_editPasswordFields: ( id )sender {
    [ passwordFields setEditing: ![ passwordFields isEditing ] ];
    editBtn = ( UIBarButtonItem * )sender;
    
    // Set edit button title to indicate toggling edit status on/off.
    [ helperObject setTitle: @"Edit" forBtn: editBtn onEditStateChangeForTable: passwordFields ];

    [self _updateRightBarButtons];
    
    changeIconButton.hidden = !changeIconButton.hidden;
    
}

-( IBAction )_addPasswordField: ( id )sender {
     // Add new row to tableview.
    [ dataSourceForPasswordLabels_array addObject: @"" ];
    [ dataSourceForPasswordValues_array addObject: @"" ];
    [ passwordFields reloadData ];
}

-( void )_updateRightBarButtons {
    // Only show add password field button during editing of table.
    if( [ passwordFields isEditing ] )
        [ rightBarButtons_array addObject: addPasswordField_btn ];
    else
    {
        [ rightBarButtons_array removeObjectAtIndex: 1 ];
    }

    self.navigationItem.rightBarButtonItems = rightBarButtons_array;
}

-( IBAction )_savePassword: ( id )sender {
    if( ![ [ passwordName text ] isEqualToString: @"" ] ) {
        passwordFields_dictionary = nil;
        passwordFields_dictionary = [ [ NSMutableDictionary alloc ] init ];
        int iPasswordFieldNumber = 0;
        for( NSString *sPasswordFieldLabel in dataSourceForPasswordLabels_array ) {
            if( ![ sPasswordFieldLabel isEqualToString: @"" ] ) {
                [ passwordFields_dictionary setValue: [ dataSourceForPasswordValues_array objectAtIndex: iPasswordFieldNumber ] forKey: sPasswordFieldLabel ];
                iPasswordFieldNumber++;
            }
        }

        if( sPasswordName != nil && ![ sPasswordName isEqualToString: @"" ] )
            [ passwordDataSource updatePassword: [ passwordName text ] withValues: passwordFields_dictionary forPassword: sPasswordName icon:iconImagePath];
        else
            [ passwordDataSource savePassword: [ passwordName text ] withValues: passwordFields_dictionary icon:iconImagePath];

        [ self.navigationController popViewControllerAnimated: YES ];
        
//#pragma mark remove this
//        passwordIcon.image = [UIImage imageNamed:iconImagePath];

    }
}


// Action for "change" button in savePassword, opens up the iconSelect view via a modal push after setting iconSelects theDelegate to this class // Elliott
-(IBAction)_changeIconButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    IconSelect *iconSelectView = (IconSelect *)[storyboard instantiateViewControllerWithIdentifier:@"IconSelect"];
    iconSelectView.theDelegate = self;
    [self presentViewController:iconSelectView animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextField Methods For DidEndOnExit

-( void )_updatePasswordLabelForPasswordField: ( id )sender {
    UITextField *textFieldEdited = ( UITextField * )sender;
    [ dataSourceForPasswordLabels_array replaceObjectAtIndex: [ textFieldEdited tag ] withObject: [ textFieldEdited text ] ];
    [ sender resignFirstResponder ];
}

-( void )_updatePasswordValueForPasswordField: ( id )sender {
    UITextField *textFieldEdited = ( UITextField * )sender;
    [ dataSourceForPasswordValues_array replaceObjectAtIndex: [ textFieldEdited tag ] withObject: [ textFieldEdited text ] ];
    [ sender resignFirstResponder ];
}

-( void )_dismissKeyboard: ( id )sender {
    [ sender resignFirstResponder ];
}

@end
