//
//  ConnectViewController.m
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "ConnectViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@interface ConnectViewController ()

@end

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
//    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
//    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                  NSDictionary* result,
//                                                  NSError *error)
//     {
//         friendsArray = [result objectForKey:@"data"];
//         
//         [[self tableView] reloadData];
//     }];
}
@end
