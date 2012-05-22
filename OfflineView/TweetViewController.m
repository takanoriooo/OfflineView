//
//  TimelineViewControllerViewController.m
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/04/29.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import "TweetViewController.h"
#import "TweetStatus.h"
#import "TweetUser.h"
#import "WebViewController.h"
#import "TwitterTimeLineLogic.h"

@interface TweetViewController ()
@property (strong, nonatomic) NSString* beforeUrl;
@property (strong, nonatomic) NSString* nextUrl;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TweetViewController

// 一度に取得するTweet件数
#define COUNT_TWEET 20

//// Storyboardで定義した定数
#define SEGUE_WEBVIEW @"WebViewSegue"
// TAG - 画面先読みのためにフッタに追加しているWebView
#define TAG_WEBVIEW_FOOTER 8
// TAG - Tweet表示のためにCell内に追加しているWebView
#define TAG_WEBVIEW_CELL 4
// アイコンの高さ。Cellの高さ計算に使用
#define HEIGHT_ICON 35
// ユーザ名・日付エリアの高さ。Cellの高さ計算に使用
#define HEIGHT_USER 13
// つぶやきメッセージの横幅。Cellの高さ計算に使用
#define WIDTH_TWEET 283

#define HEIGHT_SAMBNAIL 60

// フォントサイズ。Cellの高さ計算に使用。WebView表示時にHTMLで指定しているFontと
// 合わせる。実際に指定しているFontサイズとは異なるが、ぴったり嵌る値を指定
#define FONT_TWEET 14.0

@synthesize headerView = _headerView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize beforeUrl = _beforeUrl;
@synthesize nextUrl = _nextUrl;

#pragma mark - tableview delegate

///**
// Cellの表示直前に呼ばれる。Cellの背景色を設定する
// */
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"## %s", __FUNCTION__);
//    if (cell.tag != TAG_CELL_OLD) cell.backgroundColor = [UIColor lightGrayColor];
//}
//-(void)viewDidAppear:(BOOL)animated {
//    
//    NSArray* visibleCells = self.tableView.visibleCells;
//    for (UITableViewCell* cell in visibleCells) {
//        UIWebView *tweet = (UIWebView*)[cell viewWithTag:4];
//        [tweet loadHTMLString:@"aa" baseURL:nil];
////        [cell reloadInputViews];
////        NSLog(@"ZZ %@", cell);
////        cell.hidden = FALSE;
//    }
//}

#pragma mark - shake

/**
 シェイクを有効化
 */
- (BOOL)canBecomeFirstResponder {
    LOG_CURRENT_METHOD;
    return YES;
}

/**
 シェイク終了イベント
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    LOG_CURRENT_METHOD;

    // タイムラインを取得
    TwitterTimeLineLogic* timeLineLogic = [TwitterTimeLineLogic shareManager];
    [timeLineLogic syncTl];
}

#pragma mark - TwitterTimeLineLogicDelegate

/**
 * タイムライン取得終了
 */
- (void)didSync {
    LOG_CURRENT_METHOD;
    [self.tableView reloadData];
}


/**
 通信失敗
 */
- (void)didFailSync {
    LOG_CURRENT_METHOD;
    
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" 
                                                    message:@"タイムラインの取得に失敗しました。インターネット接続を確認して下さい"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

#pragma mark - 広告表示処理(iad) 未実装

- (void)bannerViewWillLoadAd:(ADBannerView *)banner __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) {
    LOG_CURRENT_METHOD;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    LOG_CURRENT_METHOD;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    LOG_CURRENT_METHOD;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    LOG_CURRENT_METHOD;
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    LOG_CURRENT_METHOD;
}

#pragma mark - WebView delegate

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"## %s", __FUNCTION__);
//}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    
//    LOG_CURRENT_METHOD;
////    NSLog(@"## %s url=%@", __FUNCTION__, webView.request.URL.absoluteString);
//    
//    // サムネイル用のWebView以外は無視
//    if(webView.tag != 10) {
//        return;
//    }
//
//    // 次画面で表示するURLを保持
//    self.nextUrl = webView.request.URL.absoluteString;
//    
//    // 前回と同じURLであればキャンセル
//    if([self.beforeUrl isEqualToString:webView.request.URL.absoluteString]) {
//        NSLog(@"cancel");
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveNext) object:nil];
//    }
//    
//    // 次画面へ遷移。一つのURLを読み込む際に、webViewDidFinishLoadが複数回実行されるため、
//    // 通信が終了した頃を見計らって遷移する。
//    [self performSelector:@selector(moveNext) withObject:nil afterDelay:3.0];
//}

/**
 Web画面へ遷移。遅延実行用
 */
-(void)moveNext {
    NSLog(@"## %s url=%@", __FUNCTION__, self.beforeUrl);
    [self performSegueWithIdentifier:SEGUE_WEBVIEW sender:self];
//    WebViewController* tempVC = [self.storyboard instantiateViewControllerWithIdentifier:@"webvc"];
//    [self presentModalViewController:tempVC animated:TRUE];
//    [self.presentingViewController presentingViewController]
}

/**
 Web画面の取得失敗。素早くスクロールするとCellのWebView読み込み時に本メソッドが呼ばれる模様
 文字列の表示は出来ているので、エラーは無視する
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    LOG_CURRENT_METHOD;
    NSLog(@"## %s error=%@ url=%@", __FUNCTION__, error, webView.request.URL.absoluteString);}

/**
 UIWebViewにURLを読み込んだ際に実行される。外部接続した際のみでなく、文字列を読み込んだ際にも実行される
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    LOG_CURRENT_METHOD;
    NSLog(@"## %s url=%@", __FUNCTION__, [request URL]);
    
    // URLからスキーマを取得
	NSString* scheme = [[request URL] scheme];
    
    // 空が指定されている場合、文字列を直接読み込んだと見做し、遷移を実行
	if([scheme compare:@"about"] == NSOrderedSame) {
        NSLog(@"空が指定されている場合、文字列を直接読み込んだと見做し、遷移を実行 !%@!", scheme);
        return YES;
    }    
    // http/https以外が指定されている場合、通信を行わない
	if([scheme compare:@"http"] != NSOrderedSame && [scheme compare:@"https"] != NSOrderedSame) {
        NSLog(@"http/https以外が指定されている場合、通信を行わない");
        return NO;
    }
    
    // 接続するURLはあとで判定に使用するため、保持しておく
    self.beforeUrl = [request URL].absoluteString;
    
    // TableViewCell内のwebviewであれば、ダミーWebView(フッタのWebView)へURLを読み込み、
    // キャッシュ化しておく
    if(webView.tag == TAG_WEBVIEW_CELL) {
        // フッタのWebViewを取得
//        UIWebView *fotterView = (UIWebView*)[self.view viewWithTag:TAG_WEBVIEW_FOOTER];
//        [fotterView loadRequest:request];
        
        self.nextUrl = request.URL.absoluteString;
        [self moveNext];
        // 遷移させるとCell内に表示されるため、遷移は無効にする
        NSLog(@"遷移させるとCell内に表示されるため、遷移は無効にする");
        return NO;
    }
    // フッターViewの画面遷移は有効化。高さゼロのため、アプリ上からは視認出来ない
    else if(webView.tag == TAG_WEBVIEW_FOOTER) {
        NSLog(@"フッターViewの画面遷移は有効化。高さゼロのため、アプリ上からは視認出来ない");
        return YES;
    }
    
    // ここに来るのは想定外
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" 
                                                    message:@"アプリケーションを再インストールして下さい。想定外のWebViewにロードされました"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
    NSLog(@"ここに来るのは想定外");
    return NO;
}

#pragma mark - 引っ張り対応

// このサイズ分引っ張ると更新
#define PULLDOWN_MARGIN -15.0f

/**
 引っ張りを開始すると実行される
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    LOG_CURRENT_METHOD;
    
    // 停止中に引っ張られても何もしない
    if (self.headerView.state == HeaderViewStateStopping) {
        return;
    }
    
    // ヘッダの高さを取得
    CGFloat threshold = self.headerView.frame.size.height;
    
    // 一定値引っ張られているかチェック
    if (PULLDOWN_MARGIN <= scrollView.contentOffset.y &&
        scrollView.contentOffset.y < threshold) {
        self.headerView.state = HeaderViewStatePullingDown;
        
    } else if (scrollView.contentOffset.y < PULLDOWN_MARGIN) {
        self.headerView.state = HeaderViewStateOveredThreshold;
        
    } else {
        self.headerView.state = HeaderViewStateHidden;
    }
}

/**
 引っ張りが終わったら実行される
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    LOG_CURRENT_METHOD;
    
    //    if (self.tableView.contentOffset.y < PULLDOWN_MARGIN) {
    // 一定以上引っ張られていたら分岐に入る
    if (self.headerView.state == HeaderViewStateOveredThreshold) {
        // 状態を更新
        self.headerView.state = HeaderViewStateStopping;
        // ヘッダは表示したまま
        [self setHeaderViewHidden:NO animated:YES];
        
        // 更新開始
        TwitterTimeLineLogic* timeLineLogic = [TwitterTimeLineLogic shareManager];
        [timeLineLogic syncTl];
//        [timeLineLogic sync:1 max_id:0 since_id:0];

        // 条件を満たしたら更新終了メソッドを実行
        [self performSelector:@selector(taskFinished) withObject:nil afterDelay:2.0];
    }
}

/**
 更新処理が終了したら実行される
 */
- (void)taskFinished
{
    LOG_CURRENT_METHOD;
    self.headerView.state = HeaderViewStateHidden;
    [self setHeaderViewHidden:YES animated:YES];
}

/**
 ヘッダの表示を切り替える
 */
- (void)setHeaderViewHidden:(BOOL)hidden animated:(BOOL)animated
{
    LOG_CURRENT_METHOD;
    CGFloat topOffset = 0.0;
    if (hidden) {
        topOffset = -self.headerView.frame.size.height;
    }
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
                         }];
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);        
    }
}

#pragma mark view controller

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidLoad {
    LOG_CURRENT_METHOD;
    // 変数をクリア
    self.beforeUrl = nil;
    
    // Twitterサーバからのデータ取得ロジックのDelegateとして、自身を設定
    TwitterTimeLineLogic* timeLineLogic = [TwitterTimeLineLogic shareManager];
    timeLineLogic.delegate = self;
    
    // CoreDataにデータがあれば描画を指示
    if([TweetStatus findAll].count > 0) [self didSync];
    // データが１件も無ければ初回起動とみなし、データを取得
    else [timeLineLogic sync:COUNT_TWEET max_id:0 since_id:0];
}

/**
 Segueを用いて画面遷移を実行した際に、本クラスから離れる直前に実行される。
 Web画面で表示するURLを次のViewControllerへ設定する。
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"## %s url=%@", __FUNCTION__, self.nextUrl);
    
    if ([[segue identifier] isEqualToString:SEGUE_WEBVIEW]) {
        WebViewController *viewController = (WebViewController*)[segue destinationViewController];
        viewController.url = self.nextUrl;
    }
}

#pragma mark table view controller

/**
 TableViewの総セクション数を取得
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    LOG_CURRENT_METHOD;
    return [[self.fetchedResultsController sections] count];
}

/**
 データを挿入するセクション位置を取得
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LOG_CURRENT_METHOD;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

/**
 Cellの高さを定義。ここで設定しないと、文字が省略される（あいう...のように）
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LOG_CURRENT_METHOD;
    
    // 表示する文字を取得
    TweetStatus* tweetObj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // 文字を指定Fontで表示した場合の高さを取得。Tweetエリアの高さ(9000)は意味なし
	CGSize size = [tweetObj.text sizeWithFont:[UIFont systemFontOfSize:FONT_TWEET] constrainedToSize:CGSizeMake(WIDTH_TWEET, 9000)];
    
    // ユーザ名エリア分、高さを追加
    CGFloat height = size.height + HEIGHT_USER;
    
    // イメージよりは小さくしない
    height = (height > HEIGHT_ICON ? height : HEIGHT_ICON);
    
    // Linkがあればサムネイル表示用の高さを追加する
    NSRange searchResult = [tweetObj.text rangeOfString:@"http"];
    if (searchResult.location != NSNotFound) {
        height = height + HEIGHT_SAMBNAIL;
    }
	return height;
}

/**
 TABLEの１行分のCellを作成。レイアウトの設定とデータ設定を行う。
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOG_CURRENT_METHOD;
    
    // パフォーマンス向上のため、キャッシュからCellを取得
	NSString* reuseIdentifier = @"CustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // 未設定であれば、処理を行う
//    if (cell.hidden) {
        [self configureCell:cell atIndexPath:indexPath];
//    }
    [cell reloadInputViews];
    
    // データを設定
    return cell;
}

/**
 Cell作成処理のみを抜き出し。
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LOG_CURRENT_METHOD;
    
//    if (cell.hidden) {
//    } else {
//        cell.hidden = FALSE;
//    }
    
//    cell.hidden = TRUE;
    cell.hidden = FALSE;
    
    TweetStatus* tweetObj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    TweetUser* userObj = [TweetUser findByPrimaryKey:tweetObj.userId];
    
    // cellの高さを取得
    CGFloat cellHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    
	UIImage *img = [[UIImage alloc] initWithData:userObj.profile_image_data];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    imageView.image = img;
    
    // アイコンの高さ
    CGFloat imageHeight = imageView.frame.size.height;
    
    // アイコンの高さ調整
    imageView.frame = CGRectMake(imageView.frame.origin.x, (cellHeight-imageHeight)/2, imageView.frame.size.width, imageView.frame.size.height);
    
    // ユーザ
    UILabel *userLbl = (UILabel*)[cell viewWithTag:2];
    userLbl.text = userObj.name;
    
    // 日付
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d HH:mm:ss"];  
    NSString *dateString = [dateFormatter stringFromDate:tweetObj.created_at];
    
    UILabel *timeLbl = (UILabel*)[cell viewWithTag:3];
    timeLbl.text = dateString;
    
    // tweet
    UIWebView *tweet = (UIWebView*)[cell viewWithTag:4];
    [[[tweet subviews]lastObject]setScrollEnabled:FALSE];
    
    NSString* tweetMss = [tweetObj.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
    NSString* html = [NSString stringWithFormat:@"<font size='2' style='line-height:1.3'>%@</font>", tweetMss];
    [tweet loadHTMLString:html baseURL:[NSURL URLWithString:nil]];
    
    // サムネイル用WebViewの取得
    UIWebView* sambnailWebView = (UIWebView*)[cell viewWithTag:10];
    sambnailWebView.hidden = TRUE;
    
    // URL読み込みがまだ行われていない場合（hidden=false）のみ、読み込み処理を実行
//    if (sambnailWebView.hidden) {
        
        NSError *error = NULL;
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSArray* matches = [detector matchesInString:tweetObj.text 
                                             options:0 range:NSMakeRange(0, [tweetObj.text length])];
        // URL件数分ループ ※実際は１件のみ対応
        for (int i=0; i<matches.count; i++) {
            NSTextCheckingResult* match = [matches objectAtIndex:i];
            if ([match resultType] == NSTextCheckingTypeLink) {
                
                sambnailWebView.hidden = false;
                [sambnailWebView scalesPageToFit];
                
                NSURL* url = [match URL];
                sambnailWebView.frame = CGRectMake(
                                                   sambnailWebView.frame.origin.x,
                                                   cellHeight - HEIGHT_SAMBNAIL,
                                                   sambnailWebView.frame.size.width,
                                                   sambnailWebView.frame.size.height);
                
                NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
                [sambnailWebView loadRequest:request];
//                NSLog(@"サムネイルロード開始 x=%f y=%f url=%@ mss=%@", sambnailWebView.frame.origin.x, sambnailWebView.frame.origin.y, request.URL.absoluteString, tweetMss);
                break;
            } 
        }
    //    }
    [cell reloadInputViews];
}

#pragma - mark NSFetchedResultsControllerDelegate CoreDataのデータ変更時にTABLEへ通知

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    LOG_CURRENT_METHOD;
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    LOG_CURRENT_METHOD;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    LOG_CURRENT_METHOD;
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
//            NSLog(@"## %s *** INSERT row=%d", __FUNCTION__, newIndexPath.row);
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"## %s *** DELETE", __FUNCTION__);
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            NSLog(@"## %s *** UPDATE", __FUNCTION__);
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"## %s *** MOVE", __FUNCTION__);
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    LOG_CURRENT_METHOD;
    [self.tableView endUpdates];
}

/**
 CoreDataの変更をTableへ伝えるために、NSFetchedResultsControllerを作成。
 オブザーバーパターン。
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    LOG_CURRENT_METHOD;
    
    // 作成済みであれば、新規には作らない
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // 検索・ソート条件を指定
	NSFetchRequest* fetchRequest = [TweetStatus fetchRequest];
	NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    [fetchRequest setFetchBatchSize:20];
    
    // instance化
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext contextForCurrentThread] sectionNameKeyPath:nil cacheName:@"Master"];
    
    // CoreData変更時の通知先を本クラスに指定
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
    // CoreData操作時にエラーが発生していないかチェック
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return self.fetchedResultsController;
}

@end
