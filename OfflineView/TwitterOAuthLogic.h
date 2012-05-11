//
//  TwitterOAuthLogic.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "GTMOAuthAuthentication.h"

/**
 TwitterOAuthTimeLineSyncLogic用のDelegate
 */
@protocol TwitterOAuthLogicDelegate

@required

/**
 * OAuth認証用ウィンドウを表示
 */
- (void)presentOAuthView:(UIViewController *)viewController;

/**
 認証終了後の処理
 */
- (void)didOAuth:(UIViewController*)oauthViewController;

/**
 認証失敗後の処理
 */
- (void)didOAuthFail:(UIViewController*)authViewContoller;

@end

/**
 TwitterサーバとOAuth認証を行う
 */
@interface TwitterOAuthLogic : NSObject

@property (nonatomic, assign) id<TwitterOAuthLogicDelegate> delegate;
@property (strong, nonatomic) GTMOAuthAuthentication* auth;

+(TwitterOAuthLogic*)shareManager;

/**
 OAuthを用いてユーザ認証を実施。成功すればタイムラインを取得
 */
-(void)doOAuth;

@end
