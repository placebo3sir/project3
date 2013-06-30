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

// to degrees
#define degrees(x) (180.0 * x / M_PI)
@class Calculator;


@interface Calculator : NSObject{
    IBOutlet CLLocationManager *locationManager2;
   sqlite3 *db;
}

- (void)calculatePull:(UITextField *) rwn result:(UILabel *) result startValue:(NSInteger) sv weight:(double) weight load:(NSInteger)load degreeLabel:(UILabel *) degreeLabel calculatePullLabel:(UILabel *) calculatePullLabel;
- (void) openDB; // Open database for read write data about pull (lat, lon, pull)

@property (weak, nonatomic) MainViewController *m;
@property (assign, nonatomic) unsigned long long pull;
@property (assign, nonatomic) unsigned long long degree;
@property (assign, nonatomic) unsigned long long metric;

- (NSString *)deviceLocation;
- (NSString *)currentDate;
- (NSString *)filePath;

- (void) metric:(NSInteger *)metric;
// field names: pull, date, location, weight
- (void) createTable: (NSString *) tableName
          withField1: (NSString *) date
          withField2: (NSString *) pull
          withField3: (NSString *) lat
          withField4: (NSString *) lon
          withField5: (NSString *) weight;

@end
