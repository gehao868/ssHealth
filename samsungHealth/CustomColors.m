//
//  CustomColors.m
//  samsungHealth
//
//  Created by Sylvia Fang on 8/5/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)



+ (UIColor *)myColorLightGreyBGColor {
    
    static UIColor *lightGreyBGColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightGreyBGColor = [UIColor colorWithRed:241.0 / 255.0
                                           green:241.0 / 255.0
                                            blue:241.0 / 255.0
                                           alpha:1.0];
    });
    
    return lightGreyBGColor;
}

@end
