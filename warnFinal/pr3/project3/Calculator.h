//
//  Calculator.h
//  project3
//
//  Created by goblin3 on 6/29/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
#import "MLTableAlert.h"
#import "sqlite3.h"
#import "MainViewController.h"

CMMotionManager *motionManager;
NSOperationQueue *opQ;
NSTimer *timer;
#define degrees(x) (180.0 * x / M_PI)
@class Calculator;


@interface Calculator : NSObject{
    IBOutlet CLLocationManager *locationManager2;
   sqlite3 *db;
}

- (void)calculatePull:(UITextField *) rwn result:(UILabel *) result startValue:(NSInteger) sv weight:(double) weight load:(NSInteger)load balanceLabel:(UILabel *) balanceLabel calculatePullLabel:(UILabel *) calculatePullLabel;
- (void) openDB;
@property (weak, nonatomic) MainViewController *m;
@property (assign, nonatomic) unsigned long long pull;
@property (assign, nonatomic) unsigned long long degree;
- (NSString *)deviceLocation;
- (NSString *)currentDate;
- (NSString *)filePath;

// field names: pull, date, location, weight
- (void) createTable: (NSString *) tableName
          withField1: (NSString *) date
          withField2: (NSString *) pull
          withField3: (NSString *) lat
          withField4: (NSString *) lon
          withField5: (NSString *) weight;

@end
