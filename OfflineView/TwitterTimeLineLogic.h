//
//  TwitterTimeLineLogic.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 TwitterTimeLineLogic用のDelegate
 */
@protocol TwitterTimeLineLogicDelegate

@required

/**
 * タイムライン取得終了
 */
- (void)didSync;

/**
 通信失敗
 */
- (void)didFailSync;

@end

/**
 認証ユーザのタイムラインを取得
 */
@interface TwitterTimeLineLogic : NSObject

@property (nonatomic, assign) id<TwitterTimeLineLogicDelegate> delegate;

+(TwitterTimeLineLogic*)shareManager;

/**
 タイムライン取得。パフォーマンス改善のため、２０件ずつ順に取得する
 */
- (void)syncTl;

/**
 ログインユーザのタイムライン表示処理
 @param maxCount 取得するタイムラインの件数
 @param max_id これ以前のTweetを取得する。nilであれば無視
 @param since_id これ以降のTweetを取得する。nilであれば無視
 @return 取得したTweet中、最も古いTweetのID
 */
- (void)sync:(int)count max_id:(long long)max_id since_id:(long long)since_id;

@end
