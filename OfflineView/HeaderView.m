//
//  HeaderView.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/01.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

@synthesize textLabel;
@synthesize state = state_;

/**
 初期化処理。初期はHeaderViewStateHiddenに設定
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.state = HeaderViewStateHidden;
    return self;
}

- (void)setState:(HeaderViewState)state
{
    switch (state) {
        case HeaderViewStateHidden:
//            [self.activityIndicatorView stopAnimating];
//            self.imageView.hidden = YES;
            break;
            
        case HeaderViewStatePullingDown:
//            [self.activityIndicatorView stopAnimating];
//            self.imageView.hidden = NO;
            self.textLabel.text = @"引き下げて...";
            if (state_ != HeaderViewStatePullingDown) {
//                [self _animateImageForHeadingUp:NO];
            }
            break;
            
        case HeaderViewStateOveredThreshold:
//            [self.activityIndicatorView stopAnimating];
//            self.imageView.hidden = NO;
            self.textLabel.text = @"指をはなすと更新";
            if (state_ == HeaderViewStatePullingDown) {
//                [self _animateImageForHeadingUp:YES];
            }
            break;
            
        case HeaderViewStateStopping:
//            [self.activityIndicatorView startAnimating];
            self.textLabel.text = @"更新中...";
//            self.imageView.hidden = YES;
            break;
    }
    
    state_ = state;
}


@end
