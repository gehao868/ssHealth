//
//  ConnectViewController.h
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface ConnectViewController : UIViewController
- (IBAction)showMenu:(id)sender;
- (IBAction)addFriend:(id)sender;
- (IBAction)friendDetail:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *groupsView;

@end