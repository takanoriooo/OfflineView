//
//  HeaderView.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/01.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HeaderViewStateHidden = 0,
    HeaderViewStatePullingDown,
    HeaderViewStateOveredThreshold,
    HeaderViewStateStopping
} HeaderViewState;

/**
 Twitter一覧画面の引っ張り対応に使用するヘッダビュー
 */
@interface HeaderView : UIView

@property (nonatomic, retain) IBOutlet UILabel* textLabel;
@property (nonatomic, assign) HeaderViewState state;

@end
