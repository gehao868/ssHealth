
#import "CalendarView.h"
#import <Parse/Parse.h>
#import "UserData.h"

@interface CalendarView()

{
    
    NSCalendar *gregorian;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
}

@end
@implementation CalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeleft];
        UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height-100, self.bounds.size.width, 44)];
//        [label setBackgroundColor:[DEFAULT_COLOR_THEME];
//        [label setTextColor:[UIColor whiteColor]];
//        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
//        [UILabel beginAnimations:NULL context:nil];
//        [UILabel setAnimationDuration:2.0];
//        [label setAlpha:0];
//        [UILabel commitAnimations];

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [self setCalendarParameters];
    _weekNames = @[@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa",@"Su"];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
//    _selectedDate  =components.day;
    components.day = 1;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    int weekday = [comps weekday];
//      NSLog(@"components%d %d %d",_selectedDate,_selectedMonth,_selectedYear);
    weekday  = weekday - 2;
    
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger width = 40;
    NSInteger originX = 20;
    NSInteger originY = 60;
    NSInteger monthLength = days.length;
    
    UILabel *titleText = [[UILabel alloc]initWithFrame:CGRectMake(0,20, self.bounds.size.width, 40)];
    titleText.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM yyyy"];
    NSString *dateString = [[format stringFromDate:self.calendarDate] uppercaseString];
    [titleText setText:dateString];
    [titleText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    [titleText setTextColor:[UIColor whiteColor]];
    [self addSubview:titleText];
    
    //week labels
    for (int i =0; i<_weekNames.count; i++) {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
        [weekNameLabel setFrame:CGRectMake(originX+(width*(i%columns)), originY, width, width)];
        [weekNameLabel setTitleColor:[DEFAULT_COLOR_THEME] forState:UIControlStateNormal];
        [weekNameLabel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        weekNameLabel.userInteractionEnabled = NO;
        [self addSubview:weekNameLabel];
    }
    
    //draw days
    for (NSInteger i= 0; i<monthLength; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+1;
        button.titleLabel.text = [NSString stringWithFormat:@"%d",i+1];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [button addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger offsetX = (width*((i+weekday)%columns));
        NSInteger offsetY = (width *((i+weekday)/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
        [button.layer setBorderColor:[DEFAULT_COLOR_THEME].CGColor];
        [button.layer setBorderWidth:0.5];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [DEFAULT_COLOR_THEME];
        if(((i+weekday)/columns)==0)
        {
            [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 1)];
            [button addSubview:lineView];
        }

        if(((i+weekday)/columns)==((monthLength+weekday-1)/columns))
        {
            [lineView setFrame:CGRectMake(0, button.frame.size.width - 1, button.frame.size.width, 1)];
            [button addSubview:lineView];
        }
        
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[DEFAULT_COLOR_THEME]];
        if((i+weekday)%7==0)
        {
            [columnView setFrame:CGRectMake(0, 0, 1, button.frame.size.width)];
            [button addSubview:columnView];
        }
        else if((i+weekday)%7==6)
        {
            [columnView setFrame:CGRectMake(button.frame.size.width-1, 0, 1, button.frame.size.width)];
            [button addSubview:columnView];
        }
        if(i+1 ==_selectedDate && components.month == _selectedMonth && components.year == _selectedYear)
        {
            [button setBackgroundColor:[DEFAULT_COLOR_THEME]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        
//        for (NSDate *mydate in self.recordDates) {
//            NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *mycomponents = [cal components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:mydate];
//            
//            int year = [mycomponents year];
//            int month = [mycomponents month];
//            int day = [mycomponents day];
//            
//            if (i+1 == day && components.month == month && components.year == year) {
//                [button setBackgroundColor:[DEFAULT_COLOR_THEME]];
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            }
//        }
        
        for (int j = 0; j < [self.startEnd count]; j++) {
            NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDate *startDate = [self.startEnd[j * 2] objectForKey:@"date"];
//            NSDate *endDate = [self.startEnd[j * 2 + 1] objectForKey:@"date"];
            NSDate *date = [self.startEnd[j] objectForKey:@"date"];
            NSDate *tmpDate = [date addTimeInterval:24*60*60];
            NSDateComponents *mycomponents = [cal components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:tmpDate];
            int year = [mycomponents year];
            int month = [mycomponents month];
            int day = [mycomponents day];
            
            if (i+1 == day && components.month == month && components.year == year) {
                if([[self.startEnd[j] objectForKey:@"done"] isEqualToString:@"no"]){
                    [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
                    [button.layer setBorderColor:[DEFAULT_COLOR_THEME].CGColor];
                    [button.layer setBorderWidth:3];
                    [button setBackgroundColor:[DEFAULT_COLOR_RED]];
                } else {
                    [button setBackgroundColor:[DEFAULT_COLOR_THEME]];
                }
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            
//            for ( NSDate *nextDate = startDate ; [nextDate compare:endDate] <= 0 ; nextDate = [nextDate addTimeInterval:24*60*60] ) {
//
//                NSDate *tmpDate = [nextDate addTimeInterval:24*60*60];
//                NSDateComponents *mycomponents = [cal components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:tmpDate];
//
//                int year = [mycomponents year];
//                int month = [mycomponents month];
//                int day = [mycomponents day];
//                NSLog(@"%d-%d-%d",year,month,day);
//                NSLog(@"");
//                if (i+1 == day && components.month == month && components.year == year) {
////                    [button setFrame:CGRectMake(originX+offsetX+0.5, originY+40+offsetY+0.5, width-1, width-1)];
////                    [button.layer setBorderColor:[DEFAULT_COLOR_THEME].CGColor];
////                    [button.layer setBorderWidth:1];
//                    
//                    
//                    [button setBackgroundColor:[DEFAULT_COLOR_THEME]];
//                    
//                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                }
//            }
        }
        
        [button setEnabled:NO];
            
        [self addSubview:button];
    }
    
    NSDateComponents *previousMonthComponents = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    previousMonthComponents.month -=1;
    NSDate *previousMonthDate = [gregorian dateFromComponents:previousMonthComponents];
    NSRange previousMonthDays = [c rangeOfUnit:NSDayCalendarUnit
                   inUnit:NSMonthCalendarUnit
                  forDate:previousMonthDate];
    NSInteger maxDate = previousMonthDays.length - weekday;
    
    
    for (int i=0; i<weekday; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.text = [NSString stringWithFormat:@"%d",maxDate+i+1];
        [button setTitle:[NSString stringWithFormat:@"%d",maxDate+i+1] forState:UIControlStateNormal];
        NSInteger offsetX = (width*(i%columns));
        NSInteger offsetY = (width *(i/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
        [button.layer setBorderWidth:0.5];
        [button.layer setBorderColor:[DEFAULT_COLOR_THEME].CGColor];
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[DEFAULT_COLOR_THEME]];
        if(i==0)
        {
            [columnView setFrame:CGRectMake(0, 0, 1, button.frame.size.width)];
            [button addSubview:columnView];
        }

        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:[DEFAULT_COLOR_THEME]];
        [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 1)];
        [button addSubview:lineView];
        [button setTitleColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [button setEnabled:NO];
        [self addSubview:button];
    }
    
    NSInteger remainingDays = (monthLength + weekday) % columns;
    if(remainingDays >0){
        for (int i=remainingDays; i<columns; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.text = [NSString stringWithFormat:@"%d",(i+1)-remainingDays];
            [button setTitle:[NSString stringWithFormat:@"%d",(i+1)-remainingDays] forState:UIControlStateNormal];
            NSInteger offsetX = (width*((i) %columns));
            NSInteger offsetY = (width *((monthLength+weekday)/columns));
            [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
            [button.layer setBorderWidth:0.5];
            [button.layer setBorderColor:[DEFAULT_COLOR_THEME].CGColor];
            UIView *columnView = [[UIView alloc]init];
            [columnView setBackgroundColor:[DEFAULT_COLOR_THEME]];
            if(i==columns - 1)
            {
                [columnView setFrame:CGRectMake(button.frame.size.width-1, 0, 1, button.frame.size.width)];
                [button addSubview:columnView];
            }
            UIView *lineView = [[UIView alloc]init];
            [lineView setBackgroundColor:[DEFAULT_COLOR_THEME]];
            [lineView setFrame:CGRectMake(0, button.frame.size.width-1, button.frame.size.width, 1)];
            [button addSubview:lineView];
            [button setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
            [button setEnabled:NO];
            [self addSubview:button];

        }
    }

}
-(IBAction)tappedDate:(UIButton *)sender
{
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    if(!(_selectedDate == sender.tag && _selectedMonth == [components month] && _selectedYear == [components year]))
    {
        if(_selectedDate != -1)
        {
            UIButton *previousSelected =(UIButton *) [self viewWithTag:_selectedDate];
            [previousSelected setBackgroundColor:[UIColor clearColor]];
            [previousSelected setTitleColor:[DEFAULT_COLOR_THEME] forState:UIControlStateNormal];
        }
        
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedDate = sender.tag;
        NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
        components.day = _selectedDate;
        _selectedMonth = components.month;
        _selectedYear = components.year;
        NSDate *clickedDate = [gregorian dateFromComponents:components];
        [self.delegate tappedOnDate:clickedDate];
    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
    
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month -= 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
}
-(void)setCalendarParameters
{
    if(gregorian == nil)
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
        _selectedDate  = components.day;
        _selectedMonth = components.month;
        _selectedYear = components.year;
    }
}

@end
