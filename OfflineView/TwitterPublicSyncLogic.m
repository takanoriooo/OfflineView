//
//  TwitterPublicSyncLogic.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "TwitterPublicSyncLogic.h"
#import "TweetUser.h"
#import "TweetStatus.h"

static TwitterPublicSyncLogic* instance;

@interface TwitterPublicSyncLogic()
+ (void)setInit;
@end

@implementation TwitterPublicSyncLogic

#define DATABASE @"SPDYTwitter.sqlite"
#define RESTKIT_INITIAL_URL @"http://twitter.com"

/**
 factory
 */
+(TwitterPublicSyncLogic*)shareManager {
//    NSLog(@"## %s", __FUNCTION__);
    // 作成済みなら返却
    if(instance) return instance;
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
    RKLogSetAppLoggingLevel(RKLogLevelOff);
    
    instance = [[TwitterPublicSyncLogic alloc] init];
    
    // Initialize RestKit
	RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:RESTKIT_INITIAL_URL];

    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:DATABASE];
    
    // Entityの初期化
    [TweetUser entityDescription].primaryKeyAttribute = @"id";
    [TweetStatus entityDescription].primaryKeyAttribute = @"id";
    
    //    [self setInit];
    
    return instance;
}

#pragma mark - 未使用

/**
 TwitterのJSONデータをRestKitを使って直接CoreDataへ挿入する場合の設定処理。
 */
+ (void)setInit {
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForEntityWithName:@"TweetUser" inManagedObjectStore:objectManager.objectStore];
    userMapping.primaryKeyAttribute = @"id";
    
    [userMapping mapKeyPathsToAttributes:
     @"contributors_enabled", @"contributors_enabled",
     @"created_at", @"created_at",
     @"default_profile", @"default_profile",
     @"default_profile_image", @"default_profile_image",
     @"favourites_count", @"favourites_count",
     @"follow_request_sent", @"follow_request_sent",
     @"followers_count", @"followers_count",
     @"following", @"following",
     @"friends_count", @"friends_count",
     @"geo_enabled", @"geo_enabled",
     @"id", @"id",
     @"is_translator", @"is_translator",
     @"lang", @"lang",
     @"listed_count", @"listed_count",
     @"location", @"location",
     @"name", @"name",
     @"notifications", @"notifications",
     @"profile_background_color", @"profile_background_color",
     @"profile_background_image_url", @"profile_background_image_url",
     @"profile_background_image_url_https", @"profile_background_image_url_https",
     @"profile_background_tile", @"profile_background_tile",
     @"profile_image_url", @"profile_image_url",
     @"profile_image_url_https", @"profile_image_url_https",
     @"profile_link_color", @"profile_link_color",
     @"profile_sidebar_border_color", @"profile_sidebar_border_color",
     @"profile_sidebar_fill_color", @"profile_sidebar_fill_color",
     @"profile_text_color", @"profile_text_color",
     @"profile_use_background_image", @"profile_use_background_image",
     @"protected", @"protected",
     @"screenName", @"screenName",
     @"show_all_inline_media", @"show_all_inline_media",
     @"statuses_count", @"statuses_count",
     @"time_zone", @"time_zone",
     @"url", @"url",
     @"userDescription", @"userDescription",
     @"utc_offset", @"utc_offset",
     @"verified", @"verified",
     nil];
    
    RKManagedObjectMapping* statusMapping = [RKManagedObjectMapping mappingForClass:[TweetStatus class] inManagedObjectStore:objectManager.objectStore];
    statusMapping.primaryKeyAttribute = @"id";
    [statusMapping mapKeyPathsToAttributes:
     @"created_at", @"created_at",
     @"favorited", @"favorited",
     @"id", @"id",
     @"in_reply_to_screen_name", @"in_reply_to_screen_name",
     @"in_reply_to_status_id", @"in_reply_to_status_id",
     @"in_reply_to_user_id", @"in_reply_to_user_id",
     @"retweet_count", @"retweet_count",
     @"retweeted", @"retweeted",
     @"source", @"source",
     @"text", @"text",
     @"truncated", @"truncated",
     @"url", @"url",
     nil];
    [statusMapping mapRelationship:@"user" withMapping:userMapping];
    
    // 日付フォーマットの指定
    [RKObjectMapping addDefaultDateFormatterForString:@"E MMM d HH:mm:ss Z y" inTimeZone:nil];
    
    [objectManager.mappingProvider setObjectMapping:statusMapping forResourcePathPattern:@"/status/user_timeline/:username"];
}

/**
 TwitterサーバからTweetを取得
 */
-(void)sync {
    NSLog(@"## %s", __FUNCTION__);
    
    // 既存データを削除
    NSArray* users = [TweetUser findAll];
    for (TweetUser* user in users) {
        [user deleteEntity];
    }
    
    //TODO ユーザIDを可変にする
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/status/user_timeline/zuruzirou" delegate:self];
}

/**
 Tweetの取得成功時の処理。
 */
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"## %s", __FUNCTION__);
    
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"Loaded statuses: %@", objects);
}

/**
 Tweetの取得失敗時の処理。
 */
- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"## %s", __FUNCTION__);
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:[error localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

@end
