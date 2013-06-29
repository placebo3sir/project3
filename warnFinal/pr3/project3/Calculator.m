//
//  Calculator.m
//  project3
//
//  Created by goblin3 on 6/29/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "Calculator.h"

// constants for 'types of load'
const int ROLLING_RUBBER_CONCRETE = 15;
const int ROLLING_RUBBER_GRAVEL = 20;
const int ROLLING_RUBBER_DIRT = 50;
const int ROLLINGI_STEEL_RAIL = 2;
const int SLIDING_STEEL_STEEL= 150;
const int SLIDING_STONE_STONE= 700;
const int SLIDING_STEEL_WOOD = 600;
const int SLIDING_STEEL_ICE = 30;

// constants used for pull calculation
const double ANGLE_CONSTANT = 2.222222;
const int ANGLE_DIVIDER = 100;
const int LINEPULL_CONSTANT = 707;
const int CONSTANT_N = 26;
const int FORMULA_DIVIDER = 1000;

MainViewController *m ;

#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation Calculator

#define METERS_PER_MILE  1609.33
// view lifecycle

- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"warn3.sql"];
}


// read the location of the device
- (NSString *)userLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager2.location.coordinate.latitude, locationManager2.location.coordinate.longitude];
    
    return theLocation;
}

// read date and time
- (NSString *)currentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

// here the actual pull is calculated
- (void)calculatePull{

    CMAttitude *attitude;
    CMDeviceMotion *motion = motionManager.deviceMotion;
    attitude = motion.attitude;
    
    // in relation to the 'type of load' selected, use switch statement
    // to use correct startinging values for calculation
    if(m.typeOfLoad2 == 0){ // equals 'type of load' is rolling
        switch ([m.resultLabel.text  integerValue]) {
            case 0:
                m.startValue = ROLLING_RUBBER_CONCRETE;
                break;
            case 1:
                m.startValue = ROLLING_RUBBER_GRAVEL;
                break;
            case 2:
                m.startValue = ROLLING_RUBBER_DIRT;
                break;
            default:
                m.startValue = ROLLINGI_STEEL_RAIL;
                break;
        }
    } else if(m.typeOfLoad2 != 0) { // equals 'type of load' is sliding
        switch ([m.resultLabel.text integerValue]) {
            case 0:
                m.startValue = SLIDING_STEEL_STEEL;
                break;
            case 1:
                m.startValue = SLIDING_STONE_STONE;
                break;
            case 2:
                m.startValue = SLIDING_STEEL_WOOD;
                break;
            default:
                m.startValue = SLIDING_STEEL_ICE;
                break;
        }
    }
    
    // clear input
    m.account.degree = 0;
    
    // hide keyboard
    [m.rowsNumField resignFirstResponder];
    
    // calculate pitch in degrees
    m.account.degree += degrees(attitude.pitch);
    
    // clear input
    m.account.degree2 = 0;
    
    // calculatePull amount
    m.account.degree2 = (((degrees(attitude.pitch) * ANGLE_CONSTANT / ANGLE_DIVIDER) * LINEPULL_CONSTANT) + m.startValue + CONSTANT_N ) * ([m.rowsNumField.text integerValue] / m.weight / FORMULA_DIVIDER);

    // insert into database
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO WarnHistory ('date', 'pull', 'lat', 'lon', 'weight') VALUES ('%@', '%lld', '%f', '%f', '%d')", [self currentDate], m.account.degree2, locationManager2.location.coordinate.latitude,locationManager2.location.coordinate.longitude, [m.rowsNumField.text integerValue]];
    
    NSLog(@"%ld", (long)m.startValue);
    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not insert into the requested table");
    } else {
        NSLog(@"The table has been updated");
    }
    [m show];
}

- (void)openDB {
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not connect to database");
    } else {
        NSLog(@"Connected to warn history database");
    }
}

// field names: pull, date, location, weight
- (void) createTable: (NSString *) tableName
          withField1: (NSString *) date
          withField2: (NSString *) pull
          withField3: (NSString *) lat
          withField4: (NSString *) lon
          withField5: (NSString *) weight
{
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "TEXT PRIMARY KEY, '%@' INTEGER, '%@' FLOAT, '%@' FLOAT, '%@' INTEGER );",
                     tableName, date, pull, lat, lon, weight];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not create the requested table");
    }else{
        NSLog(@"The table has been created");
    }
}
@end
