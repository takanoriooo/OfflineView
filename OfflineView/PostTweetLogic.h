//
//  PostTweetLogic.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/05.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostTweetLogic : NSObject

+(PostTweetLogic*)shareManager;
-(void)postTweet:(NSString *)text;

@end
