//
//  ViewPasswords.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 08/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "ViewPasswords.h"

@interface ViewPasswords ()

@end

@implementation ViewPasswords

@synthesize passwords;

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

-( void )viewDidAppear: ( BOOL )animated {
    helperObject = [ [ Helper alloc ] init ];
    NSUInteger tabSelected = [ self.tabBarController selectedIndex ];
    sPasswordType = [ helperObject determinePasswordTypeFromTab: tabSelected ];

    pm = nil;
    pm = [ [ PasswordsManagement alloc ] initPasswordManagementWithTemplate: sPasswordType ];
    [ pm getPasswordsFromKeychain ];
    passwordNames_array = nil;
    passwordNames_array = [ [ NSMutableArray alloc ] initWithArray: [ pm.passwords_dictionary allKeys ] ];
    passwordIcons_array = nil;
    passwordIcons_array = [ [ NSMutableArray alloc ] initWithObjects:nil];
    
    for (NSString *key in passwordNames_array) {
        NSMutableDictionary *thisPassword = [pm.passwords_dictionary valueForKey:key];
       [passwordIcons_array addObject:[thisPassword valueForKey:@"imageIcon_forPassword"]];
    }
    //for ([pm.passwords_dictionary)
    
    
    [ passwords reloadData ];

    delPasswords_btn = [ [ UIBarButtonItem alloc ] initWithTitle: @"Del"
                                                           style: UIBarButtonItemStyleBordered
                                                          target: self
                                                          action: @selector( _toggleDeleteOption: ) ];
    self.navigationItem.leftBarButtonItem = delPasswords_btn;
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-( NSInteger )numberOfSectionsInTableView: ( UITableView * )tableView {
    return 1;
}

-( NSInteger )tableView: ( UITableView * )tableView numberOfRowsInSection: ( NSInteger )section {
    return [ passwordNames_array count ];
}

#pragma mark -

-( UITableViewCell * )tableView: ( UITableView * )tableView cellForRowAtIndexPath: ( NSIndexPath * )indexPath {
    static NSString *PasswordViewIdentifier = @"PasswordViewCell";
    
    PasswordViewCell *cell = (PasswordViewCell *)[tableView dequeueReusableCellWithIdentifier:PasswordViewIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PasswordViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
     cell.nameLabel.text = [ passwordNames_array objectAtIndex: [ indexPath row ] ];
    cell.iconImage.image =  [UIImage imageNamed:[passwordIcons_array objectAtIndex:[indexPath row]]];
    return cell;
}

-( NSIndexPath * )tableView: ( UITableView * )tableView willSelectRowAtIndexPath: ( NSIndexPath * )indexPath {
    NSString *sNameOfPassword = [ passwordNames_array objectAtIndex: [ indexPath row ] ];
    UIStoryboard *storyboard = [ self storyboard ];
    SavePassword *savePasswordView = [ storyboard instantiateViewControllerWithIdentifier: @"savePassword" ];
    savePasswordView.sPasswordName = sNameOfPassword;
    [ self.navigationController pushViewController: savePasswordView animated: YES ];

    return nil;
}

-( void )tableView: ( UITableView * )tableView commitEditingStyle: ( UITableViewCellEditingStyle )editingStyle forRowAtIndexPath: ( NSIndexPath * )indexPath {
    NSInteger iRowDeleted = [ indexPath row ];
    if( [ pm deletePassword: [ passwordNames_array objectAtIndex: [ indexPath row ] ] ] ) {
        [ passwordNames_array removeObjectAtIndex: iRowDeleted ];
        [ passwords reloadData ];
    }
}

#pragma mark -
#pragma mark Methods For When Delete Button Clicked

-( IBAction )_toggleDeleteOption: ( id )sender {
    [ passwords setEditing: ![ passwords isEditing ] ];
    UIBarButtonItem *editBtn = ( UIBarButtonItem * )sender;
    
    // Set delete button title to indicate toggling delete status on/off.
    [ helperObject setTitle: @"Del" forBtn: editBtn onEditStateChangeForTable: passwords ];
}

@end
