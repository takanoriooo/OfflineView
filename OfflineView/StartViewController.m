//
//  StartViewController.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "StartViewController.h"
#import "TweetViewController.h"
#import "TweetStatus.h"

@interface StartViewController ()
@end

@implementation StartViewController

// Storyboardで定義した定数
#define SEGUE_TWEET           @"TweetSegue"
#define IDENTIFIER_TWEET_VIEW @"tweetView"

#pragma mark - TwitterOAuthLogicDelegateの実装

/**
 * OAuth認証用ウィンドウを表示
 */
- (void)presentOAuthView:(UIViewController *)viewController {
    LOG_CURRENT_METHOD;
    [self presentModalViewController:viewController animated:YES];
}

/**
 認証終了処理
 */
- (void)didOAuth:(UIViewController*)oauthViewController {
    LOG_CURRENT_METHOD;
    
    // 認証用ViewController(oauthViewController)を使用して画面遷移を行う必要があるため、
    // Segueではなく、presentModalViewControllerを自身で実行する。
    // ※おそらく、描画が完全に終わっていない状態で、認証用ウィンドウの背後にある、本クラスから
    //  画面遷移の指定は出来ないものと思われる
    if(oauthViewController) {
        TweetViewController *tweetViewController = [self.storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_TWEET_VIEW];
        [oauthViewController presentModalViewController:tweetViewController animated:YES];
    }
    // 認証用ViewControllerが存在しない場合（Keyチェーンに認証情報があった場合）は
    // segueを使って遷移
    else {
        [self performSegueWithIdentifier:SEGUE_TWEET sender:oauthViewController];
    }
}

/**
 認証失敗後の処理
 */
-(void)didOAuthFail:(UIViewController *)authViewContoller {
    LOG_CURRENT_METHOD;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:@"認証に失敗しました。インターネット接続を確認して下さい"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

/**
 Alertを閉じた際に実行される。
 認証ダイアログのクローズは、認証実行プロセス中に行っても作動しないため、本メソッドで行う。
 ※おそらく、描画が終了後にクローズ処理を実行する必要があるためだと思われる
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    LOG_CURRENT_METHOD;
    [self dismissModalViewControllerAnimated:TRUE];
}

#pragma mark - shake

- (BOOL)canBecomeFirstResponder {
    LOG_CURRENT_METHOD;
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    LOG_CURRENT_METHOD;
    if (event.type == UIEventTypeMotion &&  
        motion == UIEventSubtypeMotionShake) {

        // ログイン
        TwitterOAuthLogic* oauthLogic = [TwitterOAuthLogic shareManager];
        [oauthLogic doOAuth];
    }
}

#pragma mark - ViewController

- (void)viewDidLoad
{
    LOG_CURRENT_METHOD;
    [super viewDidLoad];
    
    // delegateを設定
    TwitterOAuthLogic* oauthLogic = [TwitterOAuthLogic shareManager];
    oauthLogic.delegate = self;
}

@end
