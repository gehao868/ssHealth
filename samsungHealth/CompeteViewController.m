//
//  CompeteViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "CompeteViewController.h"
#import "DashBoardViewController.h"


@interface CompeteViewController ()

@end

@implementation CompeteViewController

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
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:160.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    
    self.largestProgressView1 = [[DACircularProgressView alloc] initWithFrame:CGRectMake(90.0f, 80.0f, 170.0f, 170.0f)];
    [self.view addSubview: self.largestProgressView1];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange1) userInfo:nil repeats:YES];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:160.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    
    self.largestProgressView2= [[DACircularProgressView alloc] initWithFrame:CGRectMake(60.0f, 350.0f, 170.0f, 170.0f)];
    [self.view addSubview: self.largestProgressView2];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange2) userInfo:nil repeats:YES];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)progressChange1
{
    _largestProgressView1.progress += 0.003;
    
    if (_largestProgressView1.progress > 1.0f)
    {
        _largestProgressView1.progress = 0.0f;
    }
}

- (void)progressChange2
{
    _largestProgressView2.progress += 0.003;
    
    if (_largestProgressView2.progress > 1.0f)
    {
        _largestProgressView2.progress = 0.0f;
    }
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
