//
//  Util.m
//  HealthCoach
//
//  Created by Sylvia Fang on 8/15/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "Util.h"

@implementation Util
+(void)addCircleForButton:(UIButton *)btn:(float)radius{
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = radius;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 3.0f;
    btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    btn.layer.shouldRasterize = YES;
    btn.clipsToBounds = YES;
};

+(void)addCircleForImage:(UIImageView *)btn:(float)radius{
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = radius;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 3.0f;
    btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    btn.layer.shouldRasterize = YES;
    btn.clipsToBounds = YES;
};

+(void)formatTable:(UITableView *)table{
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.contentInset = UIEdgeInsetsZero;
    [table setSeparatorColor:[UIColor colorWithRed:179./255. green:204./255. blue:190./255. alpha:1]];
}

+(void)formatTextField:(UITextField *)textField{
    textField.backgroundColor = [UIColor clearColor];
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[DEFAULT_COLOR_THEME CGColor];
    textField.layer.borderWidth= 1.0f;
}

@end

