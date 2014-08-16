//
//  TableDelegate.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "TableDelegate.h"
#import "NewsFeedCell.h"
#import "Global.h"
#import "UserData.h"
#import "News.h"

@implementation TableDelegate 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Global getNewsFeed] count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NewsFeedCell";
    
    NewsFeedCell *cell = (NewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsFeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *friendAvatars = [UserData getAppFriendAvatars];
    News *news = (News *)[[Global getNewsFeed] objectAtIndex:indexPath.row];
    
    
    cell.newsContent.text = news.content;
    NSLog(@"%f", cell.newsContent.contentSize.height);
    NSLog(@"%f", cell.newsContent.frame.size.height);
    CGRect frame = cell.newsContent.frame;
    frame.size.height = cell.newsContent.contentSize.height;
    cell.newsContent.frame = frame;
    NSLog(@"%f", cell.newsContent.contentSize.height);
    NSLog(@"%f", cell.newsContent.frame.size.height);
    
    cell.likeNum.text = [[news.showlikenum stringValue] stringByAppendingString:@" likes"];
    cell.userName.text = news.postusername;
    cell.userPic.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[friendAvatars objectForKey:news.postusername]]]];
    
    return cell;
}

@end
