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
double ANGLE_CONSTANT = 2.222222;
const int ANGLE_DIVIDER = 100;
const int LINEPULL_CONSTANT = 707;
const int CONSTANT_N = 26;
const int FORMULA_DIVIDER = 1000;

#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation Calculator
@synthesize m=_m;


#define METERS_PER_MILE  1609.33

// the path to the database
- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"warn4.sql"];
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
- (void)calculatePull:(UITextField*) rwn result:(UILabel *) result startValue:(NSInteger) sv weight:(double) weight load:(NSInteger)load degreeLabel:(UILabel *)degreeLabel calculatePullLabel:(UILabel *) calculatePullLabel{
    
    if ([rwn.text intValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong input"
                                                        message:@"Input can only be an integer!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }else{
        
        CMAttitude *attitude;
        CMDeviceMotion *motion = motionManager.deviceMotion;
        attitude = motion.attitude;
        
        // in relation to the 'type of load' selected, use switch statement
        // to use correct startinging values for calculation
        if(load == 0){ // equals 'type of load' is rolling
            switch ([result.text  integerValue]) {
                case 0:
                    sv = ROLLING_RUBBER_CONCRETE;
                    break;
                case 1:
                    sv = ROLLING_RUBBER_GRAVEL;
                    break;
                case 2:
                    sv = ROLLING_RUBBER_DIRT;
                    break;
                default:
                    sv = ROLLINGI_STEEL_RAIL;
                    break;
            }
        } else if(load != 0) { // equals 'type of load' is sliding
            switch ([result.text integerValue]) {
                case 0:
                    sv = SLIDING_STEEL_STEEL;
                    break;
                case 1:
                    sv = SLIDING_STONE_STONE;
                    break;
                case 2:
                    sv = SLIDING_STEEL_WOOD;
                    break;
                default:
                    sv = SLIDING_STEEL_ICE;
                    break;
            }
        }
        
        // clear input
        self.degree = 0;
        
        // calculate pitch in degrees
        self.degree += degrees(attitude.pitch);
        
        // clear input
        self.pull= 0;
        
        // calculatePull amount
        self.pull= (((degrees(attitude.pitch) * ANGLE_CONSTANT / ANGLE_DIVIDER) * LINEPULL_CONSTANT) + sv + CONSTANT_N ) * ([rwn.text integerValue] / weight / FORMULA_DIVIDER);
        
        // insert into database
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO WarnHistory ('date', 'pull', 'lat', 'lon', 'weight') VALUES ('%@', '%lld', '%f', '%f', '%d')", [self currentDate], self.pull, locationManager2.location.coordinate.latitude,locationManager2.location.coordinate.longitude, [rwn.text integerValue]];
        
        char *err;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(0, @"Could not insert into the requested table");
        } else {
            NSLog(@"The table has been updated");
        }
    }
    
    // show pull amount
    degreeLabel.text = [NSString stringWithFormat:@"%llu °", self.degree];
    
    NSString *metricLabel;
    
    // Decide which metric to display
    if (self.metric) {
        metricLabel = @"%llu K";
    }else{
        metricLabel =  @"%llu N";;
    }
    
    // show input
    calculatePullLabel.text = [NSString stringWithFormat:metricLabel, self.pull];
    
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

- (void) metric:(NSInteger *)metrics{
    self.metric = metrics;
}
@end
