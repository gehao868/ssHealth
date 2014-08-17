//
//  NewsFeedViewController.h
//  samsungHealth
//
//  Created by Trey_L on 8/8/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINavigationMenuView.h"
#import "TableDelegate.h"
#import "DACircularProgressView.h"


@interface NewsFeedViewController : UIViewController <SINavigationMenuDelegate>
- (IBAction)showMenu;

@property (strong, nonatomic) IBOutlet UIButton *addPost;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *moreView;
@property (strong, nonatomic) TableDelegate *myTableDelegate;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

- (IBAction)more:(id)sender;
- (IBAction)managefriend:(id)sender;
- (IBAction)managegroup:(id)sender;
- (IBAction)sendgift:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *table;

@end
