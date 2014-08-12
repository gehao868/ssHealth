//
//  ConnectViewController.m
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "ConnectViewController.h"
#import "UserData.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface ConnectViewController() <FBFriendPickerDelegate>

@end

NSMutableArray *groupnames;
NSMutableArray *groupnumbers;

@implementation ConnectViewController

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
    [UserData setCurrgroup:@"Group Name"];
    
    groupnames = [[NSMutableArray alloc] init];
    groupnumbers = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(getGroups:error:)];
}

- (void)getGroups:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        [groupnames addObject:@"+"];
        for (PFObject *object in objects) {
            NSString *groupname = [object objectForKey:@"name"];
            [groupnames addObject:groupname];
            NSArray *users = [object objectForKey:@"users"];
            [groupnumbers addObject:[NSNumber numberWithInteger:users.count]];
        }
        NSLog(@"%@ %@", groupnames, groupnumbers);
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
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
}

@end
