//
//  Helper.h
//  Password Manager and File Vault
//
//  Created by Klaus McDonald-Maier on 19/07/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

-( NSString * )determinePasswordTypeFromTab: ( NSUInteger )tabSelected;
-( void )setTitle: ( NSString * )sDefaultBtnTitle forBtn: ( UIBarButtonItem * )editBtn onEditStateChangeForTable: ( UITableView * )tableView;

@end
