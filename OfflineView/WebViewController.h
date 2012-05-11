//
//  WebViewControllerViewController.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/02.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Web表示用のViewController
 */
@interface WebViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView* webview;
@property (strong, nonatomic) NSString* url;

-(IBAction)dissMiss:(id)sender;

@end
