//
//  LabelAndValueCell.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 04/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SavePassword;

@interface LabelAndValueCell : UITableViewCell

@property( nonatomic, retain )IBOutlet UITextField *fieldLabel;
@property( nonatomic, retain )IBOutlet UITextField *fieldValue;

-( id )initWithStyle: ( UITableViewCellStyle )style reuseIdentifier: ( NSString * )reuseIdentifier;

@end
