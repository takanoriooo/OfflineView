//
//  TwitterTimeLineLogic.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "TwitterTimeLineLogic.h"
#import "TwitterOAuthLogic.h"
#import "SBJsonParser.h"
#import "TweetStatus.h"
#import "TweetUser.h"

@interface TwitterTimeLineLogic()
@end

@implementation TwitterTimeLineLogic

// 一度に取得するTweet件数
#define COUNT_TWEET 20

// factory
static TwitterTimeLineLogic* instance;
static long long syncFirstTweetId = 0;
static long long syncLastTweetId = 0;

@synthesize delegate;

/**
 factory
 */
+(TwitterTimeLineLogic*)shareManager {
    LOG_CURRENT_METHOD;
    
    // 作成済みなら返却
    if(instance) return instance;
    
    instance = [[TwitterTimeLineLogic alloc] init];
    return instance;
}

- (void)syncTl {
    LOG_CURRENT_METHOD;
    
    // CoreDataに格納されている、最新のTweetのIDを取得
    NSFetchRequest* requestSearch = [TweetStatus fetchRequest];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortArray = [NSArray arrayWithObject:descriptor];
    [requestSearch setSortDescriptors:sortArray];
    
    TweetStatus* lastTweet = [TweetStatus objectWithFetchRequest:requestSearch];
    syncLastTweetId = lastTweet ? [lastTweet.id longLongValue] : 0;

    // タイムライン取得実行
    [self sync:COUNT_TWEET max_id:0 since_id:syncLastTweetId];
}

- (void)sync:(int)count max_id:(long long)max_id since_id:(long long)since_id {
    LOG_CURRENT_METHOD;

    // 要求を準備
    // 最大取得件数
    NSString* urlStr = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/home_timeline.json?count=%d&trim_user=true", count];

    // Tweetの取得範囲を指定
    // 指定ID以前のTweetのみ取得
    if(max_id != 0) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&max_id=%qi", max_id]];
    }
    // 指定ID以降、古いものから順に取得
    else if(since_id != 0) {
        // 取得済み分は対象外
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&since_id=%qi", since_id]];
    }
    NSLog(@"json url=%@", urlStr);

    // URLからrequestを作成
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];

    // requestに署名情報を付加
    TwitterOAuthLogic* oauthLogic = [TwitterOAuthLogic shareManager];
    [oauthLogic.auth authorizeRequest:request];

    // 非同期通信による取得開始
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [fetcher beginFetchWithDelegate:self didFinishSelector:@selector(homeTimelineFetcher:finishedWithData:error:)];
}

#pragma mark - タイムライン取得後の処理
/**
 タイムライン(home_timeline)取得終了の処理
 成功すればCoreDataへ値を格納する
 */
- (void)homeTimelineFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error
{
    LOG_CURRENT_METHOD;
    
    if (error != nil) {
        // タイムライン取得エラー
        NSLog(@"############## Fetching statuses/home_timeline error:%@, code= %d", error, error.code);
        [self.delegate didFailSync];
        return;
    }
    
    // タイムライン取得成功
    // JSONデータをパース
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray* timelineStatuses = [parser objectWithData:data];
    
    // 取得したTweet件数分ループ
    syncFirstTweetId = -1;
    syncLastTweetId = -1;
    for (NSDictionary* tweetDic in timelineStatuses) {
        
        // Tweet情報(TweetStatus)をCoreDataへ格納
        TweetStatus* entity = [TweetStatus createEntity];
        if (syncFirstTweetId == -1) syncFirstTweetId = [entity.id longLongValue];
        syncLastTweetId = [entity.id longLongValue];
        
        // TODO iPad実機で動かすと日付変換に失敗する。シミュレータでは成功
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
        NSDate *created_at = [inputDateFormatter dateFromString:[self getTweetData:tweetDic key:@"created_at"]];
        
        entity.created_at = created_at;
        
        entity.source = [self getTweetData:tweetDic key:@"source"];
        entity.id = [self getTweetData:tweetDic key:@"id"];
        entity.in_reply_to_screen_name = [self getTweetData:tweetDic key:@"in_reply_to_screen_name"];
        entity.id_str = [self getTweetData:tweetDic key:@"id_str"];
        entity.truncated = [self getTweetData:tweetDic key:@"truncated"];
        entity.in_reply_to_status_id = [self getTweetData:tweetDic key:@"in_reply_to_status_id"];
        entity.in_reply_to_status_id_str = [self getTweetData:tweetDic key:@"in_reply_to_status_id_str"];
        entity.in_reply_to_user_id = [self getTweetData:tweetDic key:@"in_reply_to_user_id"];
//        entity.geo = [self getTweetData:tweetDic key:@"geo"];
//        entity.place = [self getTweetData:tweetDic key:@"place"];
        entity.retweet_count = [self getTweetData:tweetDic key:@"retweet_count"];
        entity.favorited = [self getTweetData:tweetDic key:@"favorited"];
        entity.retweeted = [self getTweetData:tweetDic key:@"retweeted"];
        entity.text = [self getTweetData:tweetDic key:@"text"];
        entity.in_reply_to_user_id_str = [self getTweetData:tweetDic key:@"in_reply_to_user_id_str"];
//        entity.contributors = [self getTweetData:tweetDic key:@"contributors"];
        
        // ユーザ情報が既に存在するかチェック
        NSDictionary* userDic = [self getTweetData:tweetDic key:@"user"];
        NSNumber* userId = [self getTweetData:userDic key:@"id"];
        
        entity.userId = userId;
        
        ///////
        
        // userIdにひもづくユーザを取得
        TweetUser* userEntity = [TweetUser findByPrimaryKey:userId];
        
        if (!userEntity) {
            NSLog(@"**** userid=%@", userId);
            // ユーザがいなければ一旦UserIDだけを持つレコードを登録し、その後fetchする
            // fetchは非同期で動くため、この手順を取らないとTweet件数分、ユーザ取得処理が実行される
            TweetUser* userEntity = [TweetUser createEntity];
            userEntity.id = userId;
            
            NSString* urlStr = [NSString stringWithFormat:@"http://api.twitter.com/1/users/lookup.json?user_id=%@", userId];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"GET"];
            
            // requestに署名情報を付加
            TwitterOAuthLogic* oauthLogic = [TwitterOAuthLogic shareManager];
            [oauthLogic.auth authorizeRequest:request];
            
            // 非同期通信による取得開始
            GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
            [fetcher beginFetchWithDelegate:self didFinishSelector:@selector(userFetcher:finishedWithData:error:)];
        }
    }
    
    [[NSManagedObjectContext contextForCurrentThread] save:nil];

    // テーブルを更新
    [self.delegate didSync];
}

/**
 ユーザ情報をTwitterサーバから取得。タイムライン取得とは別スレッドで実行される
 */
- (void)userFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error {
    LOG_CURRENT_METHOD;
    
    if (error != nil) {
        // 取得エラー
        NSLog(@"############## Fetching statuses/lookup error:%@, code= %d", error, error.code);
        [self.delegate didFailSync];
        return;
    }
    
    // タイムライン取得成功
    // JSONデータをパース
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray* users = [parser objectWithData:data];
    
    if (users.count != 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" 
                                                        message:@"ユーザ情報が存在しません。再度実行して下さい"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    
    NSDictionary* userDic = [users objectAtIndex:0];
    
    // user_id
    NSNumber* userId = [self getTweetData:userDic key:@"id"];
    // user name
    NSString* userName = [self getTweetData:userDic key:@"name"];
    
    // userIdにひもづくユーザを取得
    TweetUser* userEntity = [TweetUser findByPrimaryKey:userId];
    if (!userEntity) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" 
                                                        message:@"ユーザ情報が保存されていません。アプリケーションを再インストールして下さい"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 日付を変換
    NSDate* created_at = [inputDateFormatter dateFromString:[self getTweetData:userDic key:@"created_at"]];
    
    userEntity.created_at = created_at;
    userEntity.profile_link_color = [self getTweetData:userDic key:@"profile_link_color"];
    userEntity.id = userId;
    userEntity.default_profile = [self getTweetData:userDic key:@"default_profile"];
    userEntity.lang = [self getTweetData:userDic key:@"lang"];
    userEntity.protected = [self getTweetData:userDic key:@"protected"];
    userEntity.show_all_inline_media = [self getTweetData:userDic key:@"show_all_inline_media"];
    userEntity.url = [self getTweetData:userDic key:@"url"];
    userEntity.geo_enabled = [self getTweetData:userDic key:@"geo_enabled"];
    userEntity.contributors_enabled = [self getTweetData:userDic key:@"contributors_enabled"];
    userEntity.profile_background_color = [self getTweetData:userDic key:@"profile_background_color"];
    userEntity.utc_offset = [self getTweetData:userDic key:@"utc_offset"];
    userEntity.time_zone = [self getTweetData:userDic key:@"time_zone"];
    userEntity.profile_image_url = [self getTweetData:userDic key:@"profile_image_url"];
    userEntity.follow_request_sent = [self getTweetData:userDic key:@"follow_request_sent"];
    userEntity.mydescription = [self getTweetData:userDic key:@"description"];
    userEntity.profile_use_background_image = [self getTweetData:userDic key:@"profile_use_background_image"];
    userEntity.notifications = [self getTweetData:userDic key:@"notifications"];
    userEntity.location = [self getTweetData:userDic key:@"location"];
    userEntity.profile_sidebar_border_color = [self getTweetData:userDic key:@"profile_sidebar_border_color"];
    userEntity.name = userName;
    userEntity.profile_background_tile = [self getTweetData:userDic key:@"profile_background_tile"];
    userEntity.following = [self getTweetData:userDic key:@"following"];
    userEntity.profile_sidebar_fill_color = [self getTweetData:userDic key:@"profile_sidebar_fill_color"];
    userEntity.profile_text_color = [self getTweetData:userDic key:@"profile_text_color"];
    userEntity.default_profile_image = [self getTweetData:userDic key:@"default_profile_image"];
    userEntity.followers_count = [self getTweetData:userDic key:@"followers_count"];
    userEntity.profile_background_image_url_https = [self getTweetData:userDic key:@"profile_background_image_url_https"];
    userEntity.screen_name = [self getTweetData:userDic key:@"screen_name"];
    userEntity.friends_count = [self getTweetData:userDic key:@"friends_count"];
    userEntity.is_translator = [self getTweetData:userDic key:@"is_translator"];
    userEntity.id_str = [self getTweetData:userDic key:@"id_str"];
    userEntity.statuses_count = [self getTweetData:userDic key:@"statuses_count"];
    userEntity.profile_image_url_https = [self getTweetData:userDic key:@"profile_image_url_https"];
    userEntity.verified = [self getTweetData:userDic key:@"verified"];
    userEntity.listed_count = [self getTweetData:userDic key:@"listed_count"];
    userEntity.favourites_count = [self getTweetData:userDic key:@"favourites_count"];
    userEntity.profile_background_image_url = [self getTweetData:userDic key:@"profile_background_image_url"];
    
    // iconも更新
    // ユーザアイコン設定
    NSURL *url = [NSURL URLWithString:userEntity.profile_image_url];
    NSData* imageData = [NSData dataWithContentsOfURL:url];
    
    // ユーザアイコンをCoreDataに保存
    userEntity.profile_image_data = imageData;
    
    // メモリ上のCoreDataをファイルへ保存
    [[NSManagedObjectContext contextForCurrentThread] save:nil];
    NSLog(@"sync user name=%@ userId=%@", userEntity.name, userEntity.id);
    
    // このユーザに紐づくTweetを更新し、Tableへ変更を通知する
    // ※TweetStatusを更新すると、自動で通知される
    NSArray* tweets = [TweetStatus findByAttribute:@"userId" withValue:userId];
    for (TweetStatus* tweet in tweets) {
        tweet.userName = userName;
    }
}

/**
 Dictionaryから値を取得。NSNullであればnilを返す
 */
-(id)getTweetData:(NSDictionary*)tweetDic key:(NSString*)key {
    LOG_CURRENT_METHOD;
    
    id data = [tweetDic valueForKey:key];
    if([data isEqual:[NSNull null]]) return nil;
    return data;
}

@end
