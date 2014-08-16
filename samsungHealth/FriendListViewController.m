//
//  FriendListViewController.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListViewCell.h"
#import "SendGiftViewController.h"
#import "Global.h"
#import "UserData.h"
#import "Util.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController
{
    NSMutableArray *tableData;
    NSMutableArray *thumbnails;
    NSIndexPath *currRow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableData = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    currRow = nil;
    [Util formatTable:self.friendTable];
    
    NSDictionary *dict = [UserData getAppFriendAvatars];
    NSArray *sortedArray = [[UserData getAppFriends] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *name in sortedArray) {
        [tableData addObject:name];
        [thumbnails addObject:[dict objectForKey:name]];
    }
    
    self.friendTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendListViewCell";
    
    FriendListViewCell *cell = (FriendListViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendListViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[thumbnails objectAtIndex:indexPath.row]]];
    cell.pic.image = [UIImage imageWithData:imageData];
    [Util addCircleForImage:cell.pic :20.0f];
    cell.name.text = [tableData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FriendListViewCell *tableViewCell = (FriendListViewCell *)[tableView cellForRowAtIndexPath:currRow];
    tableViewCell.checkmark.image = nil;
 
    currRow = indexPath;
    FriendListViewCell *tableViewCell1 = (FriendListViewCell *)[tableView cellForRowAtIndexPath:currRow];
    tableViewCell1.checkmark.image = [UIImage imageNamed:@"checkmark_black"];
}

- (IBAction)OK:(id)sender {
    [Global setToUserSet:YES];
    if (currRow != nil) {
        [Global setToUserName:[tableData objectAtIndex:currRow.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [Global setToUserSet:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
