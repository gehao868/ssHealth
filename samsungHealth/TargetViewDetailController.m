//
//  TargetViewDetailController.m
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "TargetViewDetailController.h"
#import <Parse/Parse.h>
#import "PNChart.h"


@interface TargetViewDetailController ()
{
    CalendarView *_sampleView;
}


@end

@implementation TargetViewDetailController{
    NSMutableArray *barData;
    NSMutableArray *barDate;
}


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
    
    [self.view setBackgroundColor:[UIColor brownColor]];
    _sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    _sampleView.delegate = self;
    [_sampleView setBackgroundColor:[UIColor whiteColor]];
    _sampleView.calendarDate = [NSDate date];
    [self.view addSubview:_sampleView];
    
    // Do any additional setup after loading the view.

    
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

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)progressChange
{
    _largestProgressView.progress += 0.003;
    
    if (_largestProgressView.progress > 1.0f)
    {
        _largestProgressView.progress = 0.0f;
    }
}

-(void)tappedOnDate:(NSDate *)selectedDate
{
    NSLog(@"tappedOnDate %@(GMT)",selectedDate);
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
