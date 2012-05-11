//
//  StartViewController.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "TwitterOAuthLogic.h"

/**
 起動画面表示用のViewController
 TwitterOAuthLogicDelegate・・・認証ロジック用のDelegate
 */
@interface StartViewController : UIViewController<TwitterOAuthLogicDelegate, UIAlertViewDelegate>
@end
