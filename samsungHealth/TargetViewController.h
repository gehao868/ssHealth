//
//  DEMOSecondViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface TargetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *goalTable;
@property (strong, nonatomic) IBOutlet UIImageView *calender;
@property (strong, nonatomic) IBOutlet UIImageView *forward;
@property (strong, nonatomic) IBOutlet UIImageView *back;

- (IBAction)showMenu;

@end
