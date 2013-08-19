//
//  LabelAndValueCell.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 04/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "LabelAndValueCell.h"
#import "SavePassword.h"

@implementation LabelAndValueCell

@synthesize fieldLabel;
@synthesize fieldValue;

-( id )initWithStyle: ( UITableViewCellStyle )style reuseIdentifier: ( NSString * )reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ) {
        NSArray *nibTopLevelObjects_array = [ [ NSArray alloc ] initWithArray:[ [ NSBundle mainBundle ] loadNibNamed: @"LabelAndValueView" owner: self options: nil ] ];
        id firstObject = [ nibTopLevelObjects_array objectAtIndex: 0 ];
        if ( [ firstObject isKindOfClass:[ UITableViewCell class ] ] )
            [ self.contentView addSubview: firstObject ];
        else
            [ self.contentView addSubview: [ nibTopLevelObjects_array objectAtIndex: 1 ] ];
    }
    
    return self;
}

-( void )setSelected: ( BOOL )selected animated: ( BOOL )animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
