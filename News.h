//
//  News.h
//  samsungHealth
//
//  Created by Trey_L on 8/9/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic) NSData *file;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *postusername;
@property (nonatomic) NSArray *likedby;
@property (nonatomic) NSNumber *likenum;
@property (nonatomic) NSNumber *showlikenum;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *groupname;
@property (nonatomic) NSString *objecid;
@property (nonatomic) NSData *media;
@end
