//
//  MainViewController.h
//  project3
//
//  Created by Osewa on 3/22/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "FlipsideViewController.h"
#import "DataViewController.h"
#import "MapViewController.h"
#import "Calculator.h"
#import <MapKit/MapKit.h>

@class MLTableAlert;

@interface MainViewController : UIViewController<FlipsideViewControllerDelegate, DataViewControllerDelegate,
MapViewControllerDelegate>{
    IBOutlet CLLocationManager *locationManager;
    sqlite3 *db;
}

@property (weak, nonatomic) IBOutlet UILabel *infoDisplayLabel5;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet UILabel *selectLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *calculatePullLabel;
@property (nonatomic, strong) IBOutlet UITextField *rowsNumField;

@property (strong, nonatomic) MLTableAlert *alert;
@property (strong, nonatomic) MLTableAlert *account;

@property (assign, nonatomic) unsigned long long amount;
@property (assign, nonatomic) unsigned long long amount2;
@property (assign, nonatomic) NSInteger startValue;
@property (assign, nonatomic) NSInteger typeOfLoad2;
@property (assign, nonatomic)double weight;


- (IBAction)showTableAlert:(id)sender;
- (void)show;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, nonatomic) UIPopoverController *dataPopoverController;
@property (strong, nonatomic) UIPopoverController *mapPopoverController;

- (IBAction)showInfo:(id)sender;
- (IBAction)showData:(id)sender;
- (IBAction)showMap:(id)sender;

// field names: pull, date, location, weight
- (void) createTable: (NSString *) tableName
         withField1: (NSString *) pull
         withField2: (NSString *) date
         withField3: (NSString *) lat
         withField4: (NSString *) lon
         withField5: (NSString *) weight;
@end
