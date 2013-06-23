//
//  DataViewController.h
//  project3
//
//  Created by goblin3 on 5/27/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@class DataViewController;
//@class MainViewController;

@protocol DataViewControllerDelegate
- (void)dataViewControllerDidFinish:(DataViewController *)controller;
@end


@interface DataViewController : UIViewController{
        sqlite3 *db;
}


@property (weak, nonatomic) id <DataViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *inputData;

- (IBAction)deleteAllTableData:(id)sender;
- (IBAction)done:(id)sender;
- (NSString *) filePath;
- (void) openDB;
@end


// mapkit tutorial