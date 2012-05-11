//
//  DetailViewController.h
//  OfflineView
//
//  Created by 耕平 照屋 on 12/05/11.
//  Copyright (c) 2012年 クオリサイトテクノロジーズ株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
