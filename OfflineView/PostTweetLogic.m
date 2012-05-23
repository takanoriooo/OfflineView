//
//  PostTweetLogic.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/05.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "PostTweetLogic.h"
#import "GTMHTTPFetcher.h"
#import "GTMOAuthAuthentication.h"
#import "TwitterOAuthLogic.h"

@implementation PostTweetLogic

// factory
static PostTweetLogic* instance;

/**
 factory
 */
+(PostTweetLogic*)shareManager {
    LOG_CURRENT_METHOD;
    
    // 作成済みなら返却
    if(instance) return instance;
    
    instance = [[PostTweetLogic alloc] init];
    return instance;
}

/**
 Tweet投稿
 */
-(void)postTweet:(NSString *)text {
    LOG_CURRENT_METHOD;
    
    // 要求を準備
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // statusパラメータをエンコードしてbodyにセット
    NSString *encodedText = [GTMOAuthAuthentication encodedOAuthParameterForString:text];
    NSString *body = [NSString stringWithFormat:@"status=%@", encodedText];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

    // requestに署名情報を付加
    TwitterOAuthLogic* oauthLogic = [TwitterOAuthLogic shareManager];
    [oauthLogic.auth authorizeRequest:request];
    
    // 接続開始
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(postTweetFetcher:finishedWithData:error:)];
}

// ツイート投稿要求に対する応答
- (void)postTweetFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error
{
    LOG_CURRENT_METHOD;
    if (error != nil) {
        // ツイート投稿取得エラー
        NSLog(@"Fetching statuses/update error: %d", error.code);
        return;
    }
}

@end
