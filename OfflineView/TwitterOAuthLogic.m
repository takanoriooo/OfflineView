//
//  TwitterOAuthLogic.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "TwitterOAuthLogic.h"
#import "GTMOAuthViewControllerTouch.h"
#import "SBJsonParser.h"
#import "TweetStatus.h"
#import "TweetUser.h"

@interface TwitterOAuthLogic()
@end

@implementation TwitterOAuthLogic

// Twitter登録情報。Twitter Developerの登録情報と同期している
#define CONSUMER_KEY    @""
#define CONSUMER_SECRET @""

// OAuth認証用の情報
#define REQUEST_TOKEN_URL @"https://api.twitter.com/oauth/request_token"
#define ACCESS_TOKEN_URL  @"https://api.twitter.com/oauth/access_token"
#define AUTHORIZE_URL     @"https://api.twitter.com/oauth/authorize"
#define SERVICE_PROVIDER  @"Twitter"
#define CALLBACK_URL      @"http://www.example.com/OAuthCallback"

/**
 factory
 */
static TwitterOAuthLogic* instance;

/**
 Aleart識別用のTAG
 */
static int const TAG_ALERT = 1;

/**
 ログイン情報を保持するKeyチェーンのキー
 */
static NSString* const kKeychainAppServiceName = @"tmp23";

@synthesize delegate;
@synthesize auth = auth_;

/**
 factory
 */
+(TwitterOAuthLogic*)shareManager {
    LOG_CURRENT_METHOD;
    
    // 作成済みなら返却
    if(instance) return instance;
    
    instance = [[TwitterOAuthLogic alloc] init];
    return instance;
}

#pragma mark - hファイルに定義したメソッド

-(void)doOAuth {
    
    // Twitterサーバ認証に使用する、GTMOAuthAuthenticationインスタンス生成
    auth_ = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                        consumerKey:CONSUMER_KEY
                                                         privateKey:CONSUMER_SECRET];

    // KeyChainから認証情報を取得
    BOOL didAuth = [GTMOAuthViewControllerTouch authorizeFromKeychainForName:kKeychainAppServiceName
                                                              authentication:auth_];
    
    // 未認証の場合は認証処理を実施
    if (!didAuth) [self signIn];
    // 認証成功
    else [self.delegate didOAuth:nil];
}

#pragma mark - privateメソッド

/**
 認証処理。ログインウィンドウを表示
 */
- (void)signIn
{
    LOG_CURRENT_METHOD;
    
    NSURL *requestTokenURL = [NSURL URLWithString:REQUEST_TOKEN_URL];
    NSURL *accessTokenURL = [NSURL URLWithString:ACCESS_TOKEN_URL];
    NSURL *authorizeURL = [NSURL URLWithString:AUTHORIZE_URL];
    
    auth_.serviceProvider = SERVICE_PROVIDER;
    auth_.callback = CALLBACK_URL;
    
    GTMOAuthViewControllerTouch *viewController;
    viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:nil
                                                               language:nil
                                                        requestTokenURL:requestTokenURL
                                                      authorizeTokenURL:authorizeURL
                                                         accessTokenURL:accessTokenURL
                                                         authentication:auth_
                                                         appServiceName:kKeychainAppServiceName
                                                               delegate:self
                                                       finishedSelector:@selector(authViewContoller:finishWithAuth:error:)];
    
    [self.delegate presentOAuthView:viewController];
}

/**
 認証処理完了。
 失敗すればアラート表示、成功すればタイムライン表示を行う
 */
- (void)authViewContoller:(GTMOAuthViewControllerTouch *)viewContoller
           finishWithAuth:(GTMOAuthAuthentication *)auth
                    error:(NSError *)error
{
    LOG_CURRENT_METHOD;
    
    // 認証失敗。オフライン時に実行すると、ここへ入る
    if (error != nil) {
        NSLog(@"認証失敗 error: %d.", error.code);
        [self.delegate didOAuthFail:viewContoller];
    }
    // 認証成功。情報表示用のWebViewを非表示に設定
    else {
        [self.delegate didOAuth:viewContoller];
    }
}

@end
