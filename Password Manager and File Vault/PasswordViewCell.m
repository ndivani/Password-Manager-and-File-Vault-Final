//
//  PasswordViewCell.m
//  Password Manager and File Vault
//
//  Created by Elliott Thompson on 07/08/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "PasswordViewCell.h"

@implementation PasswordViewCell

@synthesize nameLabel = _nameLabel;
@synthesize iconImage = _iconImage;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
