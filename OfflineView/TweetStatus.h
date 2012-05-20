//
//  TweetStatus.h
//  OfflineView
//
//  Created by Irie Ryuhei on 12/05/20.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TweetStatus : NSManagedObject

@property (nonatomic, retain) NSString * contributors;
@property (nonatomic, retain) NSString * coordinates;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSString * geo;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSString * in_reply_to_screen_name;
@property (nonatomic, retain) NSNumber * in_reply_to_status_id;
@property (nonatomic, retain) NSString * in_reply_to_status_id_str;
@property (nonatomic, retain) NSNumber * in_reply_to_user_id;
@property (nonatomic, retain) NSString * in_reply_to_user_id_str;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber * retweet_count;
@property (nonatomic, retain) NSNumber * retweeted;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * truncated;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;

@end
