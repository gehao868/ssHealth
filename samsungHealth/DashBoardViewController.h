//
//  DEMOHomeViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "DACircularProgressView.h"

@interface DashBoardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) DACircularProgressView *largestProgressView;

- (IBAction)showMenu;
@property (strong, nonatomic) IBOutlet UITableView *dashTable;


@end
