//
//  IconSelect.m
//  Password Manager and File Vault
//
//  Created by Elliott Thompson on 05/08/2013.
//  Copyright (c) 2013 Klaus McDonald-Maier. All rights reserved.
//

#import "IconSelect.h"

@interface IconSelect ()

@end

@implementation IconSelect

@synthesize theDelegate;

NSArray *iconNames;
NSArray *iconImages;

NSIndexPath *lastIndex;



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icons" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    iconNames = [dict objectForKey:@"IconNames"];
    iconImages = [dict objectForKey:@"IconImages"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return iconNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // attaches to the prototype cell "Icons",
    static NSString *CellIdentifier = @"Icons";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // adds the correct text to the label with tag 101 inside each cell
    UILabel *iconLabel = (UILabel *)[cell viewWithTag:101];
    iconLabel.text = [iconNames objectAtIndex:indexPath.row];
    
    // adds the correct image to the image with tag 102 in each cell
    UIImageView *iconImage = (UIImageView *)[cell viewWithTag:102];
    if ([iconImages objectAtIndex:indexPath.row] != @" ")
        iconImage.image = [UIImage imageNamed:[iconImages objectAtIndex:indexPath.row]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (lastIndex) {
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndex];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
     lastIndex = indexPath;
    
}


-(IBAction) done{
    if([self.theDelegate respondsToSelector:@selector(iconSelectDismissed:)])
    {
        [self.theDelegate iconSelectDismissed:[iconImages objectAtIndex:lastIndex.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
