//
//  DetailViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "DetailViewController.h"
#import "PNChart.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    
	//Add BarChart
	
	UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
	barChartLabel.textColor = PNFreshGreen;
	barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
	barChartLabel.textAlignment = NSTextAlignmentCenter;
	
	PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 70.0, SCREEN_WIDTH, 200.0)];
	barChart.backgroundColor = [UIColor clearColor];
	barChart.type = PNBarType;
	[barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
	[barChart setYValues:@[@"1",@"10",@"2",@"6",@"3"]];
	[barChart strokeChart];
	[self.view addSubview:barChartLabel];
	[self.view addSubview:barChart];
	
	// Do any additional setup after loading the view.

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
