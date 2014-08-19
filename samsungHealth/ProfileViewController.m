//
//  ProfileTableTableViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "Util.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
{
    NSArray *tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize table data
    tableData = [NSArray arrayWithObjects:@"Find Friends", @"Manage Device", @"Setting", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ProfileCell";
    
    ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [tableData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    /*UIAlertView *messageAlert = [[UIAlertView alloc]
     initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];*/
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:[tableData objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [messageAlert show];
    
    // Checked the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (IBAction)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)logOut:(id)sender {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"false" forKey:@"isLoggedin"];
}


@end
