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

@interface ConnectViewController() <FBFriendPickerDelegate>

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
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:@"invite"
                                                    title:@"title"
                                               parameters:nil
                                                  handler:nil
     ];
}

//- (IBAction)addFriend:(id)sender {
//    NSMutableDictionary *friendsPara = [[NSMutableDictionary alloc] init];
//    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends" parameters:friendsPara HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
//        NSArray *friends = [result objectForKey:@"data"];
//        
//        NSMutableArray *FBFriends = [[NSMutableArray alloc] init];
//        for (NSDictionary *dict in friends) {
//            NSMutableDictionary *elm = [[NSMutableDictionary alloc] init];
//            
//            [elm setValue:[dict objectForKey:@"name"] forKey:@"name"];
//            [elm setValue:[[[dict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"] forKey:@"pic"];
//            
//            [FBFriends addObject:elm];
//        }
//        
//        NSSortDescriptor *descriptor =
//        [[NSSortDescriptor alloc] initWithKey:@"name"
//                                    ascending:YES
//                                     selector:@selector(localizedCaseInsensitiveCompare:)];
//        
//        NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
//        NSArray *sortedFriends = [FBFriends sortedArrayUsingDescriptors:descriptors];
//        
//        [UserData setFBFriends:sortedFriends];
//    }];
//}

@end
