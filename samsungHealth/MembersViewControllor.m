//
//  Members.m
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/9/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "MembersViewControllor.h"
#import <Parse/Parse.h>
#import "CreateGroupViewControllor.h"

@interface MembersViewControllor ()

@end

@implementation MembersViewControllor {
    NSMutableArray *members;
    NSString *groupName;
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
    groupName = @"family";
    
    members = [[NSMutableArray alloc] init];
    scrollView.hidden = YES;
    [self getMemberList];
    
}

- (IBAction) show:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"add"]) {
        CreateGroupViewControllor *next = [self.storyboard instantiateViewControllerWithIdentifier:@"createGroup"];
        [self.navigationController pushViewController:next animated:YES];
    }
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
    NSInteger width = 90;
    NSInteger height = 30;
    int numberPerLine = 3;
    int count = 2;
    CGRect frame = CGRectMake(15.0f, 10.0f, width, height);
    UIButton *addFriendButton = [[UIButton alloc] initWithFrame:frame];
    [addFriendButton setFrame:frame];
    [addFriendButton setBackgroundColor:[UIColor blackColor]];
    [addFriendButton setTitle:@"add" forState:UIControlStateNormal];
    [addFriendButton addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addFriendButton];
    frame = CGRectMake(frame.origin.x + width + 10.0f , frame.origin.y, width, height);
    
    for (int i = 0; i < [members count]; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:[members objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        frame = CGRectMake(frame.origin.x + width + 10.0f , frame.origin.y, width, height);
        if (count == numberPerLine)
        {
            frame = CGRectMake(15.0f , frame.origin.y + height + 10.0f, width, height);
            count = 0;
        }
        count++;
        
    }
    scrollView.hidden = NO;
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
