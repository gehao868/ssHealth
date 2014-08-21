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
    [self.navigationItem setTitle:_type];
   
    _sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    _sampleView.delegate = self;
    
    [_sampleView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_sampleView];
    
    // Do any additional setup after loading the view.

    NSDate *today = [NSDate date];

    records = [[NSMutableArray alloc] init];
    NSMutableArray* startEnd = [[NSMutableArray alloc] init];
    _sampleView.calendarDate = today;
    _sampleView.startEnd = startEnd;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"name" equalTo:[UserData getUsername]];
    [query whereKey:@"type" equalTo:self.type];
    [query orderByAscending:@"date"];
    NSArray* objects = [query findObjects];
    _sampleView.addDate = [[objects objectAtIndex:0] objectForKey:@"date"];
    _sampleView.doneDates = [[NSMutableSet alloc] init];
    for (PFObject *object in objects) {
        if ([[object objectForKey:@"done"] isEqualToString:@"yes"]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd"];
            [_sampleView.doneDates addObject:[df stringFromDate:[object objectForKey:@"date"]]];
        }
    }
    
    //_sampleView.startEnd = [[NSMutableArray alloc] initWithArray:objects];

//    for (int i = 1; i < [objects count]; i++) {
//        if ([[objects[i] objectForKey:@"done"] isEqualToString:@"yes"]){
//            [records addObject:[objects[i] objectForKey:@"date"]];
//        }
//    }
    
//    [startEnd addObject:objects[[objects count] - 1]];
    
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
