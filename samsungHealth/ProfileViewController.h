//
//  ProfileTableTableViewController.h
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"


@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)showMenu;
- (IBAction)logOut:(id)sender;

@end
