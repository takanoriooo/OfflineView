//
//  MasterViewController.h
//  OfflineView
//
//  Created by 耕平 照屋 on 12/05/11.
//  Copyright (c) 2012年 クオリサイトテクノロジーズ株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
