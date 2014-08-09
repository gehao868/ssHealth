//
//  Members.m
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/9/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "Members.h"

@interface Members ()

@end

@implementation Members {
    NSMutableArray *members;
}

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    members = [[NSMutableArray alloc] init];
    [members addObject:@"u1"];
    [members addObject:@"u2"];
    [members addObject:@"u3"];
    [members addObject:@"u4"];
    [members addObject:@"u5"];
    [members addObject:@"u6"];
    
    NSInteger width = 80;
    NSInteger height = 30;
    int numberPerLine = 3;
    int count = 1;
    CGRect frame = CGRectMake(20.0f, 120.0f + 10 + width, width, height);

    for (int i = 0; i < [members count]; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn setTitle:[members objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
        
        frame = CGRectMake(frame.origin.x + width + 10.0f , frame.origin.y, width, height);
        if (count == numberPerLine)
        {
            frame = CGRectMake(20.0f , frame.origin.y + height + 10.0f, width, height);
            count = 0;
        }
        count++;

    }
}

- (IBAction) show:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(btn.titleLabel.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
