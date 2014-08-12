//
//  CreateGroup.m
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/9/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "UserData.h"
#import "CreateGroup.h"
#import "FriendTableViewCell.h"
#import <Parse/Parse.h>

@interface CreateGroup ()

@end

@implementation CreateGroup{
    NSMutableArray *tableData;
    NSMutableArray *thumbnails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableData = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    for (NSString *name in [UserData getAppFriends]) {
        [tableData addObject:name];
    }
    
    NSDictionary *dict = [UserData getAppFriendAvatars];

    for (NSString *key in dict) {
        [thumbnails addObject:[dict objectForKey:key]];
    }
    
    [self.groupname setText:[UserData getCurrgroup]];
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
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Added Friend" message:[tableData objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
    
    // Checked the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
