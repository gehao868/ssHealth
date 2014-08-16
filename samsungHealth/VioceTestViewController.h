//
//  VioceTestViewController.h
//  HealthCoach
//
//  Created by Trey_L on 8/16/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VioceTestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *record;
@property (strong, nonatomic) IBOutlet UIButton *stop;
@property (strong, nonatomic) IBOutlet UIButton *play;
- (IBAction)recordact:(id)sender;
- (IBAction)stopact:(id)sender;
- (IBAction)playact:(id)sender;

@end
