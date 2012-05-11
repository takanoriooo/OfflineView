//
//  TwitterPublicSyncLogic.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/**
 Twitterのpublic timelineを取得＆CoreDataへ格納する。
 RestKitとの連携サンプルとして作成したが、ユーザタイムラインでは直接JSON形式で取得することが
 出来なかったため、現在は本クラスの形式は採用していない。
 
 本クラスはRestKitの初期化にのみ使用している。
 */
@interface TwitterPublicSyncLogic : NSObject<RKObjectLoaderDelegate>

+(TwitterPublicSyncLogic*)shareManager;
-(void)sync;


@end
