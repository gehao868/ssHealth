//
//  DetailViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "DetailViewController.h"
#import "PNChart.h"
#import "Time.h"
#import <Parse/Parse.h>


@interface DetailViewController ()

@end

@implementation DetailViewController {
    NSMutableArray *barData;
    NSMutableArray *barDate;
}

@synthesize type;
@synthesize val;

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
    
    // Parse query
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];

    
    PFQuery *query = [PFQuery queryWithClassName:@"HealthData"];
    //[query whereKey:@"Time" lessThanOrEqualTo:thisWeek];
    [query whereKey:@"date" greaterThan:lastWeek];
    

    
	//Add BarChart
	
	UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
	barChartLabel.textColor = PNFreshGreen;
	barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
	barChartLabel.textAlignment = NSTextAlignmentCenter;
	
	PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 50.0, SCREEN_WIDTH, 200.0)];
	barChart.backgroundColor = [UIColor clearColor];
	barChart.type = PNBarType;
    
    
    barData = [[NSMutableArray alloc] init];
    barDate = [[NSMutableArray alloc] init];

    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd";
    
    NSArray* objects = [query findObjects];
    for (PFObject *object in objects) {
        NSNumber *step =[NSNumber numberWithInt:[[object objectForKey:self.healthDataName] intValue]];
        [barData addObject:step];
        NSString *date = [format stringFromDate:[object objectForKey:@"date"]];
        [barDate addObject:date];
    }
    
    
	[barChart setXLabels:barDate];
	[barChart setYValues:barData];
	
    
    [barChart strokeChart];
	[self.view addSubview:barChartLabel];
	[self.view addSubview:barChart];
	
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
