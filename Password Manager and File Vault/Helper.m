//
//  Helper.m
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 19/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "Helper.h"

@implementation Helper

-( NSString * )determinePasswordTypeFromTab: ( NSUInteger )tabSelected {
    NSString *sPasswordType;
    switch( tabSelected ) {
        case kLogin: sPasswordType = @"login";
            break;
        case kAccount: sPasswordType = @"account";
            break;
        case kWallet: sPasswordType = @"wallet";
            break;
    }

    return sPasswordType;
}

-( void )setTitle: ( NSString * )sDefaultBtnTitle forBtn: ( UIBarButtonItem * )editBtn onEditStateChangeForTable: ( UITableView * )tableView {
    if( [ tableView isEditing] )
        [ editBtn setTitle: @"Finish" ];
    else
        [ editBtn setTitle: sDefaultBtnTitle ];
}

@end
