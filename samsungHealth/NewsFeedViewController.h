//
//  NewsFeedViewController.h
//  samsungHealth
//
//  Created by Trey_L on 8/8/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINavigationMenuView.h"

@interface NewsFeedViewController : UIViewController <SINavigationMenuDelegate>
- (IBAction)showMenu;

@property (strong, nonatomic) IBOutlet UIButton *addPost;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *moreView;

- (IBAction)more:(id)sender;
- (IBAction)managefriend:(id)sender;
- (IBAction)managegroup:(id)sender;
- (IBAction)sendgift:(id)sender;


@end
