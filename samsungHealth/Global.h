//
//  Global.h
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

+ (NSString *) getToUserName;
+ (void) setToUserName:(NSString *) newToUserName;

+ (NSString *) getCurrGroup;
+ (void) setCurrGroup:(NSString *) newCurrGroup;

+ (BOOL) getToUserSet;
+ (void) setToUserSet: (BOOL) set;

@end
