//
//  Util.h
//  HealthCoach
//
//  Created by Sylvia Fang on 8/15/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+(void)addCircleForButton: (UIButton *)btn :(float)radius;

+(void)addCircleForImage: (UIImageView *)btn :(float)radius;

+(void)formatTable:(UITableView *)table;

+(void)formatTextField:(UITextField *)textField;

@end
