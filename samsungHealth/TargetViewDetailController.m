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
    NSMutableArray *records;
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
    [self.navigationItem setTitle:@"Goal detail"];
   
    _sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    _sampleView.delegate = self;
    
    [_sampleView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_sampleView];
    
    // Do any additional setup after loading the view.

    NSDate *today = [NSDate date];

    records = [[NSMutableArray alloc] init];

    _sampleView.recordDates = records;
    _sampleView.calendarDate = today;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    
    [query whereKey:@"type" equalTo:self.type];
    [query whereKey:@"done" equalTo:@"yes"];
    
    NSArray* objects = [query findObjects];
    
    for (PFObject *object in objects) {
        [records addObject:[object objectForKey:@"date"]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)tappedOnDate:(NSDate *)selectedDate
{
    NSLog(@"tappedOnDate %@(GMT)",selectedDate);
}



@end
