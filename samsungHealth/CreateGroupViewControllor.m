//
//  CreateGroup.m
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/9/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "UserData.h"
#import "Global.h"
#import "CreateGroupViewControllor.h"
#import "FriendTableViewCell.h"
#import <Parse/Parse.h>

@interface CreateGroupViewControllor () <UITextFieldDelegate>

@end

@implementation CreateGroupViewControllor{
    NSMutableArray *tableData;
    NSMutableArray *thumbnails;
    NSMutableSet *selectedRows;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dict = [UserData getAppFriendAvatars];
    NSArray *friendsingroup = [UserData getCurrgroupusers];
    
    selectedRows = [[NSMutableSet alloc] init];
    tableData = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    NSArray *sortedArray = [[UserData getAppFriends] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *name in sortedArray) {
        if ([friendsingroup indexOfObject:name] == NSNotFound) {
            [tableData addObject:name];
            [thumbnails addObject:[dict objectForKey:name]];
        }
    }
    
    [self.groupname setText:[Global getCurrGroup]];
    [self.groupname setDelegate:self];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(doneView)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.friends.allowsMultipleSelection = YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{    
    [textField resignFirstResponder];
    return YES;
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendTableCell";
    
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[thumbnails objectAtIndex:indexPath.row]]];
    cell.pic.image = [UIImage imageWithData:imageData];
    cell.name.text = [tableData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableViewCell.accessoryType == UITableViewCellAccessoryNone) {
        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedRows addObject:indexPath];
    } else {
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        [selectedRows removeObject:indexPath];
    }
}

-(IBAction)doneView {
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Group Member Added" message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"name" equalTo:_groupname.text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *group, NSError *error) {
        if (!error) {
            NSMutableArray *array = [group objectForKey:@"users"];
            for (NSIndexPath *indexPath in selectedRows) {
                [array addObject:[tableData objectAtIndex:indexPath.row]];
            }
            group[@"users"] = array;
            [group saveInBackground];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSIndexPath *indexPath in selectedRows) {
                [array addObject:[tableData objectAtIndex:indexPath.row]];
            }
            
            PFObject *newgroup = [PFObject objectWithClassName:@"Group"];
            newgroup[@"name"] = _groupname.text;
            newgroup[@"users"] = array;
            [newgroup saveInBackground];
        }
    }];
        
    for (NSIndexPath *indexPath in selectedRows) {
        PFQuery *query1 = [PFQuery queryWithClassName:@"Users"];
        [query1 whereKey:@"username" equalTo:[tableData objectAtIndex:indexPath.row]];
        [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                NSMutableArray *array = [user objectForKey:@"groups"];
                if (array == nil) {
                    array = [[NSMutableArray alloc] init];
                }
                [array addObject:_groupname.text];
                user[@"groups"] = array;
                [user saveInBackground];
            } else {
                // ignore
            }
        }];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
