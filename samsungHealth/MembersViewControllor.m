//
//  Members.m
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/9/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "Global.h"
#import "UserData.h"
#import "MembersViewControllor.h"
#import <Parse/Parse.h>
#import "CreateGroupViewControllor.h"
#import "Util.h"
#import "DACircularProgressView.h"

@interface MembersViewControllor ()

@end

@implementation MembersViewControllor {
    NSMutableArray *members;
    NSString *groupName;
    NSMutableArray *deleteBtns;
    BOOL isDeleting;
    int scrollHeight;
}

@synthesize scrollView;

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
    groupName = [Global getCurrGroup];
    
    members = [[NSMutableArray alloc] init];
    deleteBtns = [[NSMutableArray alloc] init];
    isDeleting = NO;
    
    //scrollView.hidden = YES;
    [self getMemberList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getMemberList {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"name" equalTo:groupName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *res = [objects objectAtIndex:0];
        __block NSMutableArray *temp = [res objectForKey:@"users"];
        for (NSObject *object in temp) {
            NSString *userName = (NSString *)object;
            [members addObject:userName];
        }
        [self fillMembers];
    }];
}

- (void) fillMembers {
    NSInteger width = 70;
    NSInteger height = 70;
    NSInteger dwidth = 20;
    NSInteger dheight = 20;
    double offset = 2.0;
    int numberPerLine = 3;
    int count = 2;
    
    CGRect frame = CGRectMake(25.0f, 10.0f, width, height);
    UIButton *addFriendButton = [[UIButton alloc] initWithFrame:frame];
    [addFriendButton setFrame:frame];
    [addFriendButton setBackgroundColor:[DEFAULT_COLOR_THEME]];
    [addFriendButton setTitle:@"+" forState:UIControlStateNormal];
    addFriendButton.titleLabel.font = [UIFont systemFontOfSize:44];
    [addFriendButton addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [Util addCircleForButton:addFriendButton:width/2];

    [scrollView addSubview:addFriendButton];
    
    NSDictionary *friendsAvatar = [UserData getAppFriendAvatars];
    frame = CGRectMake(frame.origin.x + width + 25.0f , frame.origin.y, width, height);
    CGRect dframe = CGRectMake(frame.origin.x - offset, frame.origin.y - offset, dwidth, dheight);
    
    for (int i = 0; i < [members count]; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[friendsAvatar objectForKey:[members objectAtIndex:i]]]]] forState:UIControlStateNormal];
        [Util addCircleForButton:btn:width/2];

        [btn setBackgroundColor:[DEFAULT_COLOR_THEME]];
        [btn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        
        DACircularProgressView *da = [[DACircularProgressView alloc]initWithFrame:CGRectMake(frame.origin.x - 5, frame.origin.y - 5, width + 10, height + 10)];
        [scrollView addSubview:da];
        [scrollView bringSubviewToFront:da];
        
        UIButton *dbtn = [[UIButton alloc] initWithFrame:dframe];
        [dbtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
        [dbtn setHidden:YES];
        [deleteBtns addObject:dbtn];
        [scrollView addSubview:dbtn];
        [scrollView bringSubviewToFront:dbtn];
        
        dframe = CGRectMake(frame.origin.x + width + 25.0f - offset, frame.origin.y - offset, dwidth, dheight);
        frame = CGRectMake(frame.origin.x + width + 25.0f , frame.origin.y, width, height);
        if (count == numberPerLine)
        {
            dframe = CGRectMake(25.0f - offset , frame.origin.y + height + 25.0f - offset, dwidth, dheight);
            frame = CGRectMake(25.0f , frame.origin.y + height + 25.0f, width, height);
            count = 0;
        }
       
        count++;
    }
    
    UIButton *deleteFriendBUtton = [[UIButton alloc] initWithFrame:frame];
    [deleteFriendBUtton setBackgroundColor:[DEFAULT_COLOR_RED]];
    [deleteFriendBUtton setTitle:@"delete" forState:UIControlStateNormal];
    [deleteFriendBUtton addTarget:self action:@selector(deleteFriend:) forControlEvents:UIControlEventTouchUpInside];
     [Util addCircleForButton:deleteFriendBUtton:width/2];

    [scrollView addSubview:deleteFriendBUtton];
    
    if (count == 1) {
        scrollHeight = frame.origin.y + height + 25.0f;
    } else {
        scrollHeight = frame.origin.y + (height + 25.0f) * 2;
    }
    
    //scrollView.hidden = NO;
}

- (IBAction) show:(id)sender {
    CreateGroupViewControllor *next = [self.storyboard instantiateViewControllerWithIdentifier:@"createGroup"];
    [self.navigationController pushViewController:next animated:YES];
}

- (IBAction) deleteFriend:(id)sender {
    isDeleting = !isDeleting;
    if (isDeleting) {
        for (UIButton *btn in deleteBtns) {
            [btn setHidden:NO];
        }
    } else {
        for (UIButton *btn in deleteBtns) {
            [btn setHidden:YES];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(320, scrollHeight);
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

@end
