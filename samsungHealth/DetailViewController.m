//
//  DetailViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "DetailViewController.h"
#import "PNChart.h"
#import "HealthTime.h"
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
//    
//    [components setHour:-[components hour]];
//    [components setMinute:-[components minute]];
//    [components setSecond:-[components second]];
//    
//    [components setHour:-24];
//    [components setMinute:0];
//    [components setSecond:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    NSInteger thisMonth = [components month];
    NSDate *today = [cal dateFromComponents:components];
    
//    [components setDay:([components day] - ([components weekday] - 1))];
    
    [components setDay:([components day] - 6)];

    NSDate *lastWeek  = [cal dateFromComponents:components];
//        NSLog(@"#@$@#$@#$@$@!@!@#$@$!@$@!@#$!@$@$@$%@,   %@",today,lastWeek);
    barData = [[NSMutableArray alloc] init];
    barDate = [[NSMutableArray alloc] init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    format.dateFormat = @"dd";
    NSDate *cur = lastWeek;
    while ([cur compare: today] <= 0) {
        NSDate *next = [cur dateByAddingTimeInterval:24*60*60];
        PFQuery *query = [PFQuery queryWithClassName:@"HealthData"];
        [query whereKey:@"username" equalTo:[UserData getUsername]];
        [query whereKey:@"date" greaterThan:cur];
        [query whereKey:@"date" lessThanOrEqualTo:next];
        NSArray* objects = [query findObjects];
        
        NSNumber *step = [[NSNumber alloc] init];
        if ([objects count] != 0) {
            if([[self healthDataName] isEqualToString:@"weight"]){
                double losedWeight =[[objects[0] objectForKey:self.healthDataName] doubleValue];
                double height = [[UserData getHeight] doubleValue];
                step = [NSNumber numberWithDouble:1.0 * losedWeight / ( height* height / 10000.0)];
                
            } else {
                step =[NSNumber numberWithInt:[[objects[0] objectForKey:self.healthDataName] intValue]];
            }
            [barData addObject:step];
        } else {
            [barData addObject:[NSNumber numberWithInt:0]];
        }
        NSString *date = [format stringFromDate:cur];
        [barDate addObject:date];
        cur = next;
}
    
//    PFQuery *query = [PFQuery queryWithClassName:@"HealthData"];
//    [query whereKey:@"username" equalTo:[UserData getUsername]];
//    
//    [query whereKey:@"date" greaterThan:lastWeek];
//    [query whereKey:@"date" lessThanOrEqualTo:[HealthTime getToday]];
//    [query orderByAscending:@"date"];
//    
//    NSArray* objects = [query findObjects];
//    
//    for (PFObject *object in objects) {
//        NSNumber *step = [[NSNumber alloc] init];
//        if([[self healthDataName] isEqualToString:@"weight"]){
//            double losedWeight =[[object objectForKey:self.healthDataName] doubleValue];
//            double height = [[UserData getHeight] doubleValue];
//            step = [NSNumber numberWithDouble:1.0 * losedWeight / ( height* height / 10000.0)];
//            
//        } else {
//            step =[NSNumber numberWithInt:[[object objectForKey:self.healthDataName] intValue]];
//        }
//        [barData addObject:step];
//        NSString *date = [format stringFromDate:[object objectForKey:@"date"]];
//         NSLog(@"time is %@", date);
//        [barDate addObject:date];
//    }
	//Add BarChart
	if ([self.healthDataName isEqualToString:@"step"] ||[self.healthDataName isEqualToString:@"sleep"] ||[self.healthDataName isEqualToString:@"water"]) {
        
        UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
        barChartLabel.textColor = PNCloudWhite;
        barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        barChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(6, 80.0, SCREEN_WIDTH, 215.0)];
        barChart.backgroundColor = [UIColor clearColor];
        barChart.type = PNBarType;
        
        [barChart setXLabels:barDate];
        [barChart setYValues:barData];
        [barChart strokeChart];
        [self.view addSubview:barChartLabel];
        [self.view addSubview:barChart];
    } else {
        UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
        lineChartLabel.text = @"Line Chart";
        lineChartLabel.textColor = PNFreshGreen;
        lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        lineChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNChart * lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 215.0)];
        lineChart.backgroundColor = [UIColor clearColor];
        [lineChart setXLabels:barDate];
        [lineChart setYValues:barData];
        [lineChart strokeChart];
        [self.view addSubview:lineChartLabel];
        [self.view addSubview:lineChart];
    }
    UILabel * unit = [[UILabel alloc] initWithFrame:CGRectMake(14, 70, 100, 30)];
    [unit setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    int checkVal =[self.dataValue intValue];
    
    if ([self.healthDataName isEqualToString:@"sleep"]) {
        if (checkVal > 540) {
            int quota = (checkVal - 60)/60;
            self.recommendGoal.text = [NSString stringWithFormat:@"Sleep %d hours", quota];
            self.goalTypePic.image = [UIImage imageNamed: @"sleep"];
        } else if(checkVal < 420) {
            int quota = (checkVal + 60)/60;
            self.recommendGoal.text = [NSString stringWithFormat:@"Sleep %d hours", quota];
            self.goalTypePic.image = [UIImage imageNamed: @"sleep"];
        } else {
            self.recommendGoal.text = [NSString stringWithFormat:@"Well done, keep doing!"];
            self.goalTypePic.image = [UIImage imageNamed: @"sleep"];
        }
        [unit setText:@"miniute"];
    } else if ([self.healthDataName isEqualToString:@"step"]) {
        if (checkVal< 8000) {
            int quota = checkVal + 1000;
            self.recommendGoal.text = [NSString stringWithFormat:@"Walk %d steps", quota];
            self.goalTypePic.image = [UIImage imageNamed: @"step"];
        } else {
            self.recommendGoal.text = [NSString stringWithFormat:@"Well done, keep doing!"];
            self.goalTypePic.image = [UIImage imageNamed: @"step"];
        }
        [unit setText:@"step"];
    } else if ([self.healthDataName isEqualToString:@"heartrate"]) {
        if (checkVal > 100) {
            self.recommendGoal.text = [NSString stringWithFormat:@"Exercies 30 minutes"];
            self.goalTypePic.image = [UIImage imageNamed: @"heartrate"];
        } else {
            self.recommendGoal.text = [NSString stringWithFormat:@"Well done, keep doing!"];
            self.goalTypePic.image = [UIImage imageNamed: @"heartrate"];
        }
        [unit setText:@"beat/hour"];
    } else if ([self.healthDataName isEqualToString:@"fatratio"]) {
        if (checkVal > 31) {
            self.recommendGoal.text = [NSString stringWithFormat:@"Exercies 30 minutes"];
            self.goalTypePic.image = [UIImage imageNamed: @"fatratio"];
        } else {
            self.recommendGoal.text = [NSString stringWithFormat:@"Well done, keep doing!"];
            self.goalTypePic.image = [UIImage imageNamed: @"fatratio"];
        }
        [unit setText:@"%"];
    } else if ([self.healthDataName isEqualToString:@"weight"]) {
        if (checkVal > 25) {
            self.recommendGoal.text = [NSString stringWithFormat:@"Exercies 30 minutes"];
            self.goalTypePic.image = [UIImage imageNamed: @"weight"];
        } else {
            self.recommendGoal.text = [NSString stringWithFormat:@"Well done, keep doing!"];
            self.goalTypePic.image = [UIImage imageNamed: @"weight"];
        }
        
    } else if ([self.healthDataName isEqualToString:@"cups"]) {
        if ([[UserData getGender] isEqualToString:@"female"]) {
            if (checkVal < 8) {
                int quota = checkVal + 1;
                self.recommendGoal.text = [NSString stringWithFormat:@"Drink %d cups of water", quota];
                self.goalTypePic.image = [UIImage imageNamed: @"cups"];
            } else {
                self.recommendGoal.text = [NSString stringWithFormat:@"Well done, keep doing!"];
                self.goalTypePic.image = [UIImage imageNamed: @"cups"];
            }
        } else if ([[UserData getGender] isEqualToString:@"male"]) {
            if (checkVal < 13) {
                int quota = checkVal + 1;
                self.recommendGoal.text = [NSString stringWithFormat:@"Drink %d cups of water", quota];
                self.goalTypePic.image = [UIImage imageNamed: @"cups"];
            } else {
                self.recommendGoal.text = [NSString stringWithFormat:@"Well done, keep doing!"];
                self.goalTypePic.image = [UIImage imageNamed: @"cups"];
            }
        }
        [unit setText:@"cup"];
    }
    
    if ([[self healthDataName] isEqualToString:@"weight"]) {
        self.title = @"BMI";
    } else {
        self.title = [self healthDataName];
    }
    [unit setTextColor:[UIColor whiteColor]];
    [self.view addSubview:unit];
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
