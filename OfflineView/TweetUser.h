//
//  TweetUser.h
//  OfflineView
//
//  Created by Irie Ryuhei on 12/05/20.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TweetUser : NSManagedObject

@property (nonatomic, retain) NSNumber * contributors_enabled;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * default_profile;
@property (nonatomic, retain) NSNumber * default_profile_image;
@property (nonatomic, retain) NSNumber * favourites_count;
@property (nonatomic, retain) NSNumber * follow_request_sent;
@property (nonatomic, retain) NSNumber * followers_count;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSNumber * friends_count;
@property (nonatomic, retain) NSNumber * geo_enabled;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSNumber * is_translator;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSNumber * listed_count;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * mydescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * notifications;
@property (nonatomic, retain) NSString * profile_background_color;
@property (nonatomic, retain) NSString * profile_background_image_url;
@property (nonatomic, retain) NSString * profile_background_image_url_https;
@property (nonatomic, retain) NSNumber * profile_background_tile;
@property (nonatomic, retain) NSData * profile_image_data;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * profile_image_url_https;
@property (nonatomic, retain) NSString * profile_link_color;
@property (nonatomic, retain) NSString * profile_sidebar_border_color;
@property (nonatomic, retain) NSString * profile_sidebar_fill_color;
@property (nonatomic, retain) NSString * profile_text_color;
@property (nonatomic, retain) NSNumber * profile_use_background_image;
@property (nonatomic, retain) NSNumber * protected;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSNumber * show_all_inline_media;
@property (nonatomic, retain) NSNumber * statuses_count;
@property (nonatomic, retain) NSString * time_zone;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) NSNumber * utc_offset;
@property (nonatomic, retain) NSNumber * verified;

@end
