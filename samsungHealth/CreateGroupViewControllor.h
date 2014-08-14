//
//  CreateGroup.h
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/9/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateGroupViewControllor : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *groupname;
@property (strong, nonatomic) IBOutlet UITableView *friends;

@end
