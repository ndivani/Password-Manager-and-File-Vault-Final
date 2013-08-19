//
//  IconSelect.h
//  Password Manager and File Vault
//
//  Created by Elliott Thompson on 05/08/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondDelegate <NSObject>
-(void) iconSelectDismissed:(NSString *) iconPath;
@end
 
@interface IconSelect : UIViewController <UITableViewDelegate, UITableViewDataSource>
{

}

@property (nonatomic, assign) id <SecondDelegate> theDelegate;

-(IBAction)done;

@end
