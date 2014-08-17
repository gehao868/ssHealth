//
//  NewPostViewController.h
//  samsungHealth
//
//  Created by Trey_L on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;
- (IBAction)send:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *postText;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *photo;

- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addPhoto:(id)sender;


@end
