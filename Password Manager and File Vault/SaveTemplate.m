//
//  SaveTemplate.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 08/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "SaveTemplate.h"

@interface SaveTemplate ()

@end

@implementation SaveTemplate

@synthesize templateFields;
@synthesize nameOfTemplate;
@synthesize addTemplateField;
@synthesize sTemplateName;

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
    editTemplateFields_btn = [ [ UIBarButtonItem alloc ] initWithTitle: @"Edit"
                                                                 style: UIBarButtonItemStyleBordered
                                                                target: self
                                                                action: @selector( _editTemplateFields: ) ];

    addTemplateField_btn = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                                                            target: self
                                                                            action: @selector( _addTemplateField: ) ];

    rightBarButtons_array = [ [ NSMutableArray alloc ] initWithObjects: editTemplateFields_btn, nil ];
    self.navigationItem.rightBarButtonItems = rightBarButtons_array;

    helperObject = [ [ Helper alloc ] init ];
    NSUInteger tabSelected = [ self.tabBarController selectedIndex ];
    NSString *sPasswordType = [ helperObject determinePasswordTypeFromTab: tabSelected ];

    passwordDataSource = [ [ PasswordsManagement alloc ] initPasswordManagementWithTemplate: sPasswordType ];
    [ passwordDataSource getTemplatesFromPlist ];

    if( sTemplateName != nil && ![ sTemplateName isEqualToString: @"" ] ) {
        dataSourceForTemplateFields_array = [ [ NSMutableArray alloc ] initWithArray: [ passwordDataSource.templates_dictionary objectForKey: sTemplateName ] ];
        if( [ dataSourceForTemplateFields_array count ] == 0 ) {
            [ dataSourceForTemplateFields_array addObject: @"" ];
        }
    } else {
        dataSourceForTemplateFields_array = [ [ NSMutableArray alloc ] initWithObjects: @"", nil ];
    }

    if( ![ sTemplateName isEqualToString: @"" ] )
        [ nameOfTemplate setText: sTemplateName ];

    [ nameOfTemplate addTarget: self
                        action: @selector( _dismissKeyboard: )
              forControlEvents: UIControlEventEditingDidEndOnExit ];

    iTemplateIconSelection = -1;
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
    return [ dataSourceForTemplateFields_array count ] > 0 ? [ dataSourceForTemplateFields_array count ] : 1;
}

-( UITableViewCell * )tableView: ( UITableView * )tableView cellForRowAtIndexPath: ( NSIndexPath * )indexPath {
    LabelCell *tableViewCell = ( LabelCell * )[ tableView dequeueReusableCellWithIdentifier: @"TemplateLabel" ];
    if( tableViewCell == nil ) {
        tableViewCell = [ [ LabelCell alloc ] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"TemplateLabel" ];
    }

    // Set UITextField delegate methods for when text changes.
    [ tableViewCell.templateField addTarget: self
                                     action: @selector( _updateDataForTemplateField: )
                           forControlEvents: UIControlEventEditingDidEndOnExit ];

    [ tableViewCell.templateField addTarget: self
                                     action: @selector( _updateDataForTemplateField: )
                           forControlEvents: UIControlEventEditingDidEnd ];

    [ tableViewCell.templateField setText: [ dataSourceForTemplateFields_array objectAtIndex: [ indexPath row ] ] ];

    [ tableViewCell.templateField setTag: [ indexPath row ] ];

    return tableViewCell;
}

-( BOOL )tableView: ( UITableView * )tableView canEditRowAtIndexPath: ( NSIndexPath * )indexPath {
    return YES;
}

-( BOOL )tableView: ( UITableView * )tableView canMoveRowAtIndexPath: ( NSIndexPath * )indexPath {
    return NO;
}

#pragma mark -
#pragma mark UITableView Delegate Methods

-( void )tableView: ( UITableView * )tableView commitEditingStyle: ( UITableViewCellEditingStyle )editingStyle forRowAtIndexPath: ( NSIndexPath * )indexPath {
    NSInteger iRowDeleted = [ indexPath row ];
    [ dataSourceForTemplateFields_array removeObjectAtIndex: iRowDeleted ];
    [ templateFields reloadData ];
}

#pragma mark -
#pragma mark Methods For When UI Buttons For UITableView Clicked

-( IBAction )_editTemplateFields: ( id )sender {
    [ templateFields setEditing: ![ templateFields isEditing ] ];
    UIBarButtonItem *editBtn = ( UIBarButtonItem * )sender;

    // Set edit button title to indicate toggling edit status on/off.
    [ helperObject setTitle: @"Edit" forBtn: editBtn onEditStateChangeForTable: templateFields ];

    [ self _updateRightBarButtons ];
}

-( IBAction )_addTemplateField: ( id )sender {
    // Add new row to tableview.
    [ dataSourceForTemplateFields_array addObject: @"" ];
    [ templateFields reloadData ];
}

-( void )_updateRightBarButtons {
    // Only show add password field button during editing of table.
    if( [ templateFields isEditing ] )
        [ rightBarButtons_array addObject: addTemplateField_btn ];
    else
        [ rightBarButtons_array removeObjectAtIndex: 1 ];

    self.navigationItem.rightBarButtonItems = rightBarButtons_array;
}

-( IBAction )_saveTemplate: ( id )sender {
    if( ![ [ nameOfTemplate text ] isEqualToString: @"" ] ) {
        int iLoopCount = 0;
        for( NSString *sTemplateFieldName in dataSourceForTemplateFields_array ) {
            if( [ sTemplateFieldName isEqualToString: @"" ] ) {
                [ dataSourceForTemplateFields_array removeObjectAtIndex: iLoopCount ];
            }

            iLoopCount++;
        }

        // Check UIImageView for image, and store image name if exists.
        if( iTemplateIconSelection > -1 )
            [ dataSourceForTemplateFields_array addObject: [ self _getTemplateIconFileName ] ];

        if( [ passwordDataSource updateNewTemplate: [ nameOfTemplate text ] withNewTemplateData: dataSourceForTemplateFields_array forTemplate: sTemplateName ] ) {
            // Success.
        }

        [ self.navigationController popViewControllerAnimated: YES ];
    }
}

-( NSString * )_getTemplateIconFileName {
    NSString *sTemplateIconFileName;
    switch( iTemplateIconSelection ) {
        case kVideo:
            sTemplateIconFileName = @"TICON_107-widescreen.png";
            break;
        case kShopping:
            sTemplateIconFileName = @"TICON_80-shopping-cart.png";
            break;
        case kDocuments:
            sTemplateIconFileName = @"TICON_33-cabinet.png";
            break;
        case kIdentification:
            sTemplateIconFileName = @"TICON_15-tags.png";
            break;
        case kFinances:
            sTemplateIconFileName = @"TION_162-receipt.png";
            break;
        default:
            sTemplateIconFileName = @"";
    }

    return sTemplateIconFileName;
}

#pragma mark -
#pragma mark UITextField Methods For DidEndOnExit

-( void )_updateDataForTemplateField: ( id )sender {
    UITextField *textFieldEdited = ( UITextField * )sender;
    [ dataSourceForTemplateFields_array replaceObjectAtIndex: [ textFieldEdited tag ] withObject: [ textFieldEdited text ] ];
    [ sender resignFirstResponder ];
}

-( void )_dismissKeyboard: ( id )sender {
    [ sender resignFirstResponder ];
}

@end
