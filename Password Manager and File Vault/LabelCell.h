//
//  LabelCell.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 08/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelCell : UITableViewCell

@property( nonatomic, retain )IBOutlet UITextField *templateField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
