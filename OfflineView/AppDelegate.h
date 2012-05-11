//
//  AppDelegate.h
//  SPDYTwitter
//
//  Created by Irie Ryuhei on 12/05/03.
//  Copyright (c) 2012年 qualysite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

/**
 iOSアプリケーションの起点となるクラス。
 mainから実行され、初期画面の表示を行う
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
