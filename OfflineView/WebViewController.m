//
//  WebViewControllerViewController.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/02.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@end

@implementation WebViewController

@synthesize  webview = _webview;
@synthesize url = _url;

#pragma mark - 本クラスで定義したメソッド

-(IBAction)dissMiss:(id)sender {
    LOG_CURRENT_METHOD;
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - shake

- (BOOL)canBecomeFirstResponder {
    LOG_CURRENT_METHOD;
    return YES;
}

<<<<<<< HEAD
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {  
=======
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
>>>>>>> 不要なコメントを削除
    LOG_CURRENT_METHOD;
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - view controller

-(void)viewWillAppear:(BOOL)animated {
    LOG_CURRENT_METHOD;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    NSLog(@"## %s url=%@", __FUNCTION__, self.url);
    [super viewDidLoad];

    // Tweet画面で選択されたWebを表示。urlはTweet画面で設定されたものを使用。
    // Tweet画面でキャッシュ済みのため、NSURLRequestReturnCacheDataDontLoadを指定
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60]];
}

/**
 端末の向き変更時の処理。Web閲覧のため、横向きも可能。
 使いやすさを考慮して、PortraitUpsideDownのみ変更不可
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    LOG_CURRENT_METHOD;
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
