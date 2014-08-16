//
//  TableDelegate.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#define gap 5.0f

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIFont *font =  [UIFont systemFontOfSize:14.0f];
    float imgHeight = 47.0f;
    float likesHeight = 21.0f;
    
    News *news = (News *)[[Global getNewsFeed] objectAtIndex:indexPath.row];
    
    NSDictionary *userAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize textSize = [news.content sizeWithAttributes:userAttributes];
    
    float newsHeight = ceil((ceil(textSize.width / 300.0f) + 1) * font.lineHeight);
    newsHeight = MAX(newsHeight, 28.0f);
    
    return gap + imgHeight + gap + newsHeight + gap + likesHeight;
}



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
    CGRect frame = cell.newsContent.frame;
    
//    NSLog(@"the line number is %f", cell.newsContent.contentSize.height / cell.newsContent.font.lineHeight);
    
    NSDictionary *userAttributes = @{NSFontAttributeName: cell.newsContent.font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize textSize = [cell.newsContent.text sizeWithAttributes:userAttributes];
    
//    cell.newsContent.contentSize.height = 28.0f;
    frame.size.height = ceil((ceil(textSize.width / 300.0f) + 1) * cell.newsContent.font.lineHeight);
    if (frame.size.height < 28.0f) {
        frame.size.height = 28.0f;
    }
    cell.newsContent.frame = frame;
   
    cell.likeNum.text = [[news.showlikenum stringValue] stringByAppendingString:@" likes"];
    cell.userName.text = news.postusername;
    cell.userPic.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[friendAvatars objectForKey:news.postusername]]]];
    
    
    CGRect likeFrame = cell.likeNum.frame;
    NSLog(@"like starting point is %f" @" index at %ld", cell.likeNum.frame.origin.y ,(long)indexPath.row);
    likeFrame.origin.y = cell.newsContent.frame.origin.y + cell.newsContent.frame.size.height + gap;
    
    NSLog(@"news height is %f" @" index at %ld", cell.newsContent.frame.size.height, (long)indexPath.row);
    NSLog(@"news size width %f" @" index at %ld", textSize.width, (long)indexPath.row);
    
    cell.likeNum.frame = likeFrame;
    NSLog(@"like starting point is %f" @" index at %ld", cell.likeNum.frame.origin.y ,(long)indexPath.row);
    return cell;
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    
}
@end
