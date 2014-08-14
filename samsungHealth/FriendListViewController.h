//
//  FriendListViewController.h
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *label;
- (IBAction)OK:(id)sender;
- (IBAction)cancel:(id)sender;

@end
