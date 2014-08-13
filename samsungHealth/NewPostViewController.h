//
//  NewPostViewController.h
//  samsungHealth
//
//  Created by Trey_L on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *sendPost;
- (IBAction)send:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *postText;

@end
