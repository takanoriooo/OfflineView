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
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - shake

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {  
    NSLog(@"## %s", __FUNCTION__);
    
//    [self dismissModalViewControllerAnimated:YES];
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - view controller

- (void)viewDidLoad
{
    NSLog(@"## %s url=%@", __FUNCTION__, self.url);
    [super viewDidLoad];

    // Tweet画面で選択されたWebを表示。urlはTweet画面で設定されたものを使用。
    // Tweet画面でキャッシュ済みのため、NSURLRequestReturnCacheDataDontLoadを指定
//    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:60]];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60]];
//    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10]];
}

/**
 端末の向き変更時の処理。Web閲覧のため、横向きも可能。
 使いやすさを考慮して、PortraitUpsideDownのみ変更不可
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
