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
#import "UserData.h"
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
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    NSInteger thisMonth = [components month];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    
    barData = [[NSMutableArray alloc] init];
    barDate = [[NSMutableArray alloc] init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd";
    
    PFQuery *query = [PFQuery queryWithClassName:@"HealthData"];
    [query whereKey:@"username" equalTo:[UserData getUsername]];
    [query whereKey:@"date" greaterThan:lastWeek];
    
    NSArray* objects = [query findObjects];
    
    for (PFObject *object in objects) {
        NSNumber *step =[NSNumber numberWithInt:[[object objectForKey:self.healthDataName] intValue]];
        [barData addObject:step];
        NSString *date = [format stringFromDate:[object objectForKey:@"date"]];
        [barDate addObject:date];
    }

	//Add BarChart
	if ([self.healthDataName isEqualToString:@"step"] ||[self.healthDataName isEqualToString:@"sleep"] ||[self.healthDataName isEqualToString:@"water"]) {
        
        UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
        barChartLabel.textColor = PNCloudWhite;
        barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        barChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 50.0, SCREEN_WIDTH, 230.0)];
        barChart.backgroundColor = [UIColor clearColor];
        barChart.type = PNBarType;
        
        [barChart setXLabels:barDate];
        [barChart setYValues:barData];
        
        
        [barChart strokeChart];
        [self.view addSubview:barChartLabel];
        [self.view addSubview:barChart];
    } else {
        
    }
    
    self.title = [self healthDataName];
    self.monthLabel.text = [self getMonthName:thisMonth];
}

- (NSString* )getMonthName:(int)thisMonth {
    
    switch (thisMonth) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
    }
    return @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
