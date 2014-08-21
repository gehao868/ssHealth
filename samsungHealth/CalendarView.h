

#import <UIKit/UIKit.h>
@protocol CalendarDelegate <NSObject>

-(void)tappedOnDate:(NSDate *)selectedDate;

@end

@interface CalendarView : UIView
{
    NSInteger _selectedDate;
    NSArray *_weekNames;
}

@property (nonatomic,strong) NSDate *calendarDate;

@property (nonatomic,strong) NSMutableArray *startEnd;

@property (nonatomic,strong) NSDate *addDate;

@property (nonatomic,strong) NSMutableSet *doneDates;

@property (nonatomic,weak) id<CalendarDelegate> delegate;

@end
