//
//  TimelineViewControllerViewController.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/04/29.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <RestKit/RestKit.h>
#import "HeaderView.h"
#import "TwitterTimeLineLogic.h"

/**
 Tweet一覧画面表示用のViewController
 UIWebViewDelegate・・・Web画面へ遷移前にキャッシュするため、イベントハンドラを捕まえるために使用
 ADBannerViewDelegate・・・広告バナー表示用
 */
@interface TweetViewController : UITableViewController<NSFetchedResultsControllerDelegate, UIWebViewDelegate, TwitterTimeLineLogicDelegate, ADBannerViewDelegate>

/**
 CoreData変更時のイベントを受け取るためにNSFetchedResultsControllerを保持
 */
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

/**
 引っ張り対応対応用のヘッダビュー。現在は未実装
 */
@property (strong, nonatomic) IBOutlet HeaderView* headerView;

@end