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

@interface DashBoardViewController : UIViewController


@property (strong, nonatomic) DACircularProgressView *largestProgressView;
@property (strong, nonatomic) NSMutableArray *subProgessView;

- (IBAction)showMenu;
@property (strong, nonatomic) IBOutlet UITableView *dashTable;
@property (strong, nonatomic) IBOutlet UIButton *liked;
- (IBAction)likedAction:(id)sender;


@end
