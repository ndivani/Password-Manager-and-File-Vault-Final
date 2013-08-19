//
//  ViewTemplates.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 08/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "ViewTemplates.h"

@interface ViewTemplates ()

@end

@implementation ViewTemplates

@synthesize templates;

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
    Helper *helperObject = [ [ Helper alloc ] init ];
    NSUInteger tabSelected = [ self.tabBarController selectedIndex ];
    NSString *sPasswordType = [ helperObject determinePasswordTypeFromTab: tabSelected ];

    passwordsDataSource = nil;
    passwordsDataSource = [ [ PasswordsManagement alloc ] initPasswordManagementWithTemplate: sPasswordType ];
    [ passwordsDataSource getTemplatesFromPlist ];
    [ self _updatePickerViewDataSource ];

    if( [ templates_array count ] > 0 ) {
        if( [ templates selectedRowInComponent: 0 ])
        sTemplateName = [ templates_array objectAtIndex: 0 ];
        iPickerRowSelected = 0;
        [ templates selectRow: 0 inComponent: 0 animated: NO ];
    }
}

-( void )viewWillDisappear: ( BOOL )animated {
    passwordsDataSource = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-( IBAction )_createPassword: ( id )sender {
    if( sTemplateName != nil && ![ sTemplateName isEqualToString: @"" ] ) {
        UIStoryboard *storyboard = [ self storyboard ];
        SavePassword *savePasswordView = [ [ SavePassword alloc ] init ];
        savePasswordView = [ storyboard instantiateViewControllerWithIdentifier: @"savePassword" ];
        savePasswordView.sTemplateName = sTemplateName;
        [ self.navigationController pushViewController: savePasswordView animated: YES ];
        savePasswordView = nil;
    }
}

-( IBAction )_deleteTemplate: ( id )sender {
    if( sTemplateName != nil && ![ sTemplateName isEqualToString: @"" ] ) {
        if( [ passwordsDataSource deleteTemplate: sTemplateName ] ) {
            [ templates_array removeObjectIdenticalTo: sTemplateName ];
            [ templates reloadAllComponents ];
            if( [ templates_array count ] == 0 ) {
                sTemplateName = @"";
                iPickerRowSelected = -1;
            } else {
                if( [ templates_array count ] == iPickerRowSelected )
                    iPickerRowSelected -= 1;

                [ templates selectRow: iPickerRowSelected inComponent: 0 animated: NO ];
                sTemplateName = [ templates_array objectAtIndex: iPickerRowSelected ];
            }
        }
    }
}

-( IBAction )_createTemplate: ( id )sender {
    [ self.navigationController pushViewController: [ self _prepareViewForTemplateDataEntry: @"" ] animated: YES ];
    templateView = nil;
    [ self _updatePickerViewDataSource ];
}

-( IBAction )_editTemplate: ( id )sender {
    if( sTemplateName != nil && ![ sTemplateName isEqualToString: @"" ] ) {
        [ self.navigationController pushViewController: [ self _prepareViewForTemplateDataEntry: sTemplateName ] animated: YES ];
        templateView = nil;
        [ self _updatePickerViewDataSource ];
    }
}

-( SaveTemplate * )_prepareViewForTemplateDataEntry: ( NSString * )sNameOfTemplateToPrepare {
    UIStoryboard *storyboard = [ self storyboard ];
    templateView = [ [ SaveTemplate alloc ] init ];
    templateView = [ storyboard instantiateViewControllerWithIdentifier: @"saveTemplate" ];
    templateView.sTemplateName = sNameOfTemplateToPrepare;
    return templateView;
}

-( void )_updatePickerViewDataSource {
    [ passwordsDataSource getTemplatesFromPlist ];
    templates_array = nil;
    templates_array = [ [ NSMutableArray alloc ] initWithObjects: @"Blank", nil ];
    for( NSString *sNextTemplateName in [ passwordsDataSource.templates_dictionary allKeys ] ) {
        [ templates_array addObject: sNextTemplateName ];
    }

    // iOS 6 crashes on scroll with no picker values. Use this line of code as work-around instead of
    // checking for 0 templates in datasource and returning 1 (numberOfRowsInComponent) / nil (titleForRow).
    [ templates setUserInteractionEnabled: [ templates_array count ] > 0 ];
    [ templates reloadAllComponents ];
}

#pragma mark -
#pragma mark UIPickerView DataSource Methods

-( NSInteger )numberOfComponentsInPickerView: ( UIPickerView * )pickerView {
    return 1;
}

-( NSInteger )pickerView: ( UIPickerView * )pickerView numberOfRowsInComponent: ( NSInteger )component {
    return [ templates_array count ];
}

#pragma mark -
#pragma mark UIPickerView Delegate Methods

-( NSString * )pickerView: ( UIPickerView * )pickerView titleForRow: ( NSInteger )row forComponent: ( NSInteger )component {
    return [ templates_array objectAtIndex: row ];
}

-( void )pickerView: ( UIPickerView * )pickerView didSelectRow: ( NSInteger )row inComponent: ( NSInteger )component {
    sTemplateName = [ templates_array objectAtIndex: row ];
    iPickerRowSelected = row;
}

@end
