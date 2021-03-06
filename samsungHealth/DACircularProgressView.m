//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation DACircularProgressView

@synthesize trackTintColor = _trackTintColor;
@synthesize progressTintColor =_progressTintColor;
@synthesize progress = _progress;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
    self.radius = MIN(rect.size.height, rect.size.width) / 2;
    
    CGFloat pathWidth = self.radius * 0.0f;
    CGFloat radians = DEGREES_2_RADIANS((self.progress*359.9)-90);
    CGFloat xOffset = self.radius*(1 + 0.85*cosf(radians));
    CGFloat yOffset = self.radius*(1 + 0.85*sinf(radians));
    CGPoint endPoint = CGPointMake(xOffset, yOffset);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.radius < 80){
        _trackTintColor = [UIColor clearColor];
    } else {
        _trackTintColor = [UIColor colorWithRed:102.0f/255.0f green:119.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
    }
    [self.trackTintColor setFill];
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, self.radius, DEGREES_2_RADIANS(-90), DEGREES_2_RADIANS(270), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);

//gradient color
    UIImage* image = [UIImage imageNamed:@"gradient"];
    if(self.radius < 80){
        self.progressTintColor =[DEFAULT_COLOR_GREEN];
        if(self.progress < 0.6f) {
            self.progressTintColor = [DEFAULT_COLOR_RED];
        } else if (self.progress < 0.8f) {
            self.progressTintColor = [DEFAULT_COLOR_YELLOW];
        }
    [self.progressTintColor setFill];
//     resize gradient
//        CGSize newSize = CGSizeMake(60.0f, 60.0f);
//        UIGraphicsBeginImageContext( newSize );
//        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        image = newImage;
    } else {
        [[UIColor colorWithPatternImage:image] setFill];
    }
    
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, self.radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 0, pathWidth, pathWidth));
    CGContextFillPath(context);
    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2, endPoint.y - pathWidth/2, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    CGContextSetBlendMode(context, kCGBlendModeClear);;
    CGFloat innerRadius = self.radius * 0.85;
	CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);    
	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
	CGContextFillPath(context);
}

#pragma mark - Property Methods

- (UIColor *)trackTintColor
{
    if (!_trackTintColor)
    {
        _trackTintColor = [UIColor colorWithRed:168.0f/255.0f green:191.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor
{
    return _progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)color{
    _progressTintColor = color;
}

- (void)setProgress:(float)progress
{
    if (progress < 0.007) {
        if (self.radius >= 80)
        _progress = 0.007;
        else _progress = 0.00001;
    } else {
        _progress = progress;
    }
    [self setNeedsDisplay];
}

@end
