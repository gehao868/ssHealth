//
//  FriendListViewController.h
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *label;
- (IBAction)OK:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *friendTable;

@end
