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
#import "UserData.h"


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
    NSMutableArray* startEnd = [[NSMutableArray alloc] init];
    _sampleView.recordDates = records;
    _sampleView.calendarDate = today;
    _sampleView.startEnd = startEnd;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"name" equalTo:[UserData getUsername]];
    [query whereKey:@"type" equalTo:self.type];
    //[query whereKey:@"done" equalTo:@"yes"];
    
    NSArray* objects = [query findObjects];
    PFObject *lastObj = objects[0];
    [startEnd addObject:[lastObj objectForKey:@"date"]];
    for (PFObject *object in objects) {
        int value =  [[object objectForKey:@"expected"] intValue];
        if ([[object objectForKey:@"done"] isEqualToString:@"yes"]) {
            [records addObject:[object objectForKey:@"date"]];
        }
        if (value != [[lastObj objectForKey:@"expected"] intValue]) {
            [startEnd addObject:[lastObj objectForKey:@"date"]];
            [startEnd addObject:[object objectForKey:@"date"]];
        }
        lastObj = object;
        
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
