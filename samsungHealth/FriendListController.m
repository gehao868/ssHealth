//
//  FriendListController.m
//  samsungHealth
//
//  Created by Sylvia Fang on 7/28/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "FriendListController.h"
#import "FriendTableViewCell.h"
#import "UserData.h"

#import <FacebookSDK/FacebookSDK.h>

@interface FriendListController ()

@end

@implementation FriendListController
{
    NSMutableArray *tableData;
    NSMutableArray *thumbnails;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Initialize table data and thumbnails
    tableData = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [UserData getFBFriends]) {
        [tableData addObject:[dict objectForKey:@"name"]];
        [thumbnails addObject:[dict objectForKey:@"pic"]];
    }

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
    static NSString *simpleTableIdentifier = @"FriendCell";
    
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[thumbnails objectAtIndex:indexPath.row]]];
    cell.name.text = [tableData objectAtIndex:indexPath.row];
    cell.pic.image = [UIImage imageWithData:imageData];
    cell.pic.layer.masksToBounds = YES;
    cell.pic.layer.cornerRadius = 20.0;
    cell.pic.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.pic.layer.borderWidth = 2.0f;
    cell.pic.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.pic.layer.shouldRasterize = YES;
    cell.pic.clipsToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:@"invite"
                                                    title:@"title"
                                               parameters:nil
                                                  handler:nil
                                                  ];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
