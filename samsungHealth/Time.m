//
//  Time.m
//  samsungHealth
//
//  Created by Hao Ge on 8/4/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "Time.h"

@implementation Time {
    
}
@synthesize today;
@synthesize yesterday;
@synthesize thisWeek;
@synthesize lastWeek;
@synthesize thisMonth;
@synthesize lastMonth;

-(void)setTime {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
    lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    lastMonth = [cal dateFromComponents:components];
}


@end
