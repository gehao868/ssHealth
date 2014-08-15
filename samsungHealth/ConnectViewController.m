//
//  ConnectViewController.m
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "ConnectViewController.h"
#import "CreateGroupViewControllor.h"
#import "UserData.h"
#import "Global.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface ConnectViewController() <FBFriendPickerDelegate>

@end

@implementation ConnectViewController {
    NSMutableArray *groupnames;
    NSMutableArray *groupnumbers;
    NSString *preGroup;
    int scrollHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UserData setCurrgroupusers:[[NSArray alloc] init]];
    preGroup = [Global getCurrGroup];
    
    groupnames = [[NSMutableArray alloc] init];
    groupnumbers = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(getGroups:error:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [Global setCurrGroup:preGroup];
}

- (void)getGroups:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        for (PFObject *object in objects) {
            NSString *groupname = [object objectForKey:@"name"];
            [groupnames addObject:groupname];
            NSArray *users = [object objectForKey:@"users"];
            [groupnumbers addObject:[NSNumber numberWithInteger:users.count]];
            [self fillGroups];
        }
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)fillGroups {
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"circle_cyan", @"circle_red", @"circle_orange", @"circle_yellow", nil];
    
    NSInteger width = 140;
    NSInteger height = 140;
    int numberPerLine = 2;
    int count = 1;
    
    CGRect frame = CGRectMake(20.0f, 20.0f, width, height);
    UIButton *addFriendButton = [[UIButton alloc] initWithFrame:frame];
    [addFriendButton setFrame:frame];
    [addFriendButton setBackgroundImage:[UIImage imageNamed:[colorArray objectAtIndex:colorArray.count-1]] forState:UIControlStateNormal];
    [addFriendButton setTitle:@"Create(+)" forState:UIControlStateNormal];
    [addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    [_groupsView addSubview:addFriendButton];
    frame = CGRectMake(frame.origin.x + width, frame.origin.y, width, height);
    
    for (int i = 0; i < [groupnames count]; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn setBackgroundImage:[UIImage imageNamed:[colorArray objectAtIndex:i%colorArray.count]] forState:UIControlStateNormal];
        NSString *title = [[NSString alloc] initWithFormat:@"%@(%@)", [groupnames objectAtIndex:i], [groupnumbers objectAtIndex:i]];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(friendDetail:) forControlEvents:UIControlEventTouchUpInside];
        [_groupsView addSubview:btn];
        frame = CGRectMake(frame.origin.x + width, frame.origin.y, width, height);
        count++;
        if (count == numberPerLine)
        {
            frame = CGRectMake(20.0f, frame.origin.y + height + 10.0f, width, height);
            count = 0;
        }
    }
    
    if (count == 0) {
        scrollHeight = frame.origin.y + height + 10.0f;
    } else {
        scrollHeight = frame.origin.y + (height + 10.0f) * 2;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.groupsView.contentSize = CGSizeMake(320, scrollHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)addFriend:(id)sender {
    [Global setCurrGroup:@"New Group Name"];
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"Create(+)"]) {
        CreateGroupViewControllor *next = [self.storyboard instantiateViewControllerWithIdentifier:@"createGroup"];
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (IBAction)friendDetail:(id)sender {
    UIButton *button = (UIButton*)sender;
    [Global setCurrGroup:[button.titleLabel.text substringToIndex:[button.titleLabel.text rangeOfString:@"("].location]];
    ConnectViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MembersViewControllor"];
    [self.navigationController pushViewController:next animated:YES];
    self.navigationItem.hidesBackButton = NO;
}

@end
