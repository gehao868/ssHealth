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
    [query orderByAscending:@"date"];
    NSArray* objects = [query findObjects];
    _sampleView.startEnd = objects;
//    [startEnd addObject:objects[0]];
    for (int i = 1; i < [objects count]; i++) {
        NSLog(@"%@",[objects[i - 1] objectForKey:@"date"]);
        int last = [[objects[i - 1] objectForKey:@"expected"] intValue];
        int cur = [[objects[i] objectForKey:@"expected"] intValue];
        if ([[objects[i] objectForKey:@"done"] isEqualToString:@"yes"]){
            [records addObject:[objects[i] objectForKey:@"date"]];
        }
//        if (last != cur) {
//            [startEnd addObject:objects[i - 1]];
//            [startEnd addObject:objects[i]];
//            NSLog(@"%@ %d, %@ %d",[objects[i - 1] objectForKey:@"date"], last, [objects[i] objectForKey:@"date"], cur);
//        }
    }
    
    [startEnd addObject:objects[[objects count] - 1]];
    
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
