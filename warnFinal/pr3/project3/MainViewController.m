//
//  MainViewController.m
//  project3
//
//  Created by Osewa on 3/22/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "MainViewController.h"
//#import "FlipsideViewController.h"
//#import "DataViewController.h"
//#import "MapViewController.h"

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
const int FORMULA_DIVERDER = 1000;

@interface MainViewController ()
@end

@implementation MainViewController
#define METERS_PER_MILE  1609.33
@synthesize account=_account;
@synthesize amount=_amount;
@synthesize amount2=_amount2;
@synthesize balanceLabel=_balanceLabel;
@synthesize calculatePullLabel=_calculatePullLabel;
@synthesize infoDisplayLabel5;

- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"warn2.sql"];
}

- (void)openDB {
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not connect to database");
    } else {
        NSLog(@"Connected to warn history database");
    }
}

// view lifecycle
#define degrees(x) (180.0 * x / M_PI)
- (void)viewDidLoad {
    [self openDB];
    [self createTable: @"WarnHistory" withField1: @"Date" withField2:@"Pull" withField3:@"Lat" withField4:@"Lon" withField5:@"Weight"];
    
    [super viewDidLoad];
    // create account
    self.account = [[MLTableAlert alloc] init];
    self.weight = 1.0;
    [self show];
    
	// proces device motion (angle)
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
    [motionManager startDeviceMotionUpdates];
    
    // proces device location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(readAngle) userInfo:nil repeats:YES];
}

- (void)viewDidUnload {
    [self setInfoDisplayLabel5:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    // Dispose of any resources that can be recreated.
    [super didReceiveMemoryWarning];
}

// read the angle in relatie to the ground in which the device is hold. Ouputs the pitch in degrees
-(void)readAngle {
    CMAttitude *attitude;
    CMDeviceMotion *motion = motionManager.deviceMotion;
    attitude = motion.attitude;
    NSString *pitch = [NSString stringWithFormat:@"Pitch = %f", degrees(attitude.pitch)];
    infoDisplayLabel5.text = pitch;
}

// read the location of the device
- (NSString *)userLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    
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
- (IBAction)calculatePull:(id)sender {
    CMAttitude *attitude;
    CMDeviceMotion *motion = motionManager.deviceMotion;
    attitude = motion.attitude;
    
    // in relation to the 'type of load' selected, use switch statement
    // to use correct startinging values for calculation
    if(self.typeOfLoad2 == 0){ // equals 'type of load' is rolling
        switch ([self.resultLabel.text  integerValue]) {
            case 0:
                self.startValue = ROLLING_RUBBER_CONCRETE;
                break;
            case 1:
                self.startValue = ROLLING_RUBBER_GRAVEL;
                break;
            case 2:
                self.startValue = ROLLING_RUBBER_DIRT;
                break;
            default:
                self.startValue = ROLLINGI_STEEL_RAIL;
                break;
        }
    } else if(self.typeOfLoad2 != 0) { // equals 'type of load' is sliding
        switch ([self.resultLabel.text integerValue]) {
            case 0:
                self.startValue = SLIDING_STEEL_STEEL;
                break;
            case 1:
                self.startValue = SLIDING_STONE_STONE;
                break;
            case 2:
                self.startValue = SLIDING_STEEL_WOOD;
                break;
            default:
                self.startValue = SLIDING_STEEL_ICE;
                break;
        }
    }
    
    // clear input
    self.account.degree = 0;
    
    // hide keyboard
    [self.rowsNumField resignFirstResponder];
    
    // calculate pitch in degrees
    self.account.degree += degrees(attitude.pitch);
    
    // clear input
    self.account.degree2 = 0;
    
    // calculatePull amount
    self.account.degree2 = (((degrees(attitude.pitch) * ANGLE_CONSTANT / ANGLE_DIVIDER) * LINEPULL_CONSTANT) + self.startValue + CONSTANT_N ) * ([self.rowsNumField.text integerValue] / self.weight / FORMULA_DIVERDER);
    
    // insert into database
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO WarnHistory ('date', 'pull', 'lat', 'lon', 'weight') VALUES ('%@', '%lld', '%f', '%f', '%d')", [self currentDate], self.account.degree2, locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude, [self.rowsNumField.text integerValue]];
    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not insert into the requested table");
    } else {
        NSLog(@"The table has been updated");
    }
    [self show];
}

- (void)show {
    // show pull amount
    self.balanceLabel.text = [NSString stringWithFormat:@"%llu °", self.account.degree];
    // show input
    self.calculatePullLabel.text = [NSString stringWithFormat:@"%llu N", self.account.degree2];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// the popup table where users can pick a underground type
-(IBAction)showTableAlert:(id)sender {
    NSMutableArray *load;
    
    if(self.typeOfLoad2 == 0) // 'type of load' = rolling
        load = [NSMutableArray arrayWithObjects: @"Concrete", @"Gravel", @"Dirt", @"Steel rail", nil];
    else
        load = [NSMutableArray arrayWithObjects: @"Steel on steel", @"Stone on stone", @"Steel on Wood", @"Steel on ice", nil];
    
	// popup the table
	self.alert = [MLTableAlert tableAlertWithTitle:@"Choose an option..." cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section){
                        return [load count];
                  }
                        andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                        static NSString *CellIdentifier = @"CellIdentifier";
                        UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil)
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                      
                        cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1,  [load objectAtIndex:indexPath.row] ];
                      
                        return cell;
                  }];
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex) {
        
        self.resultLabel.text = [NSString stringWithFormat:@"%d", selectedIndex.row];
        self.selectLabel.text = [NSString stringWithFormat:@"%@", [load objectAtIndex:selectedIndex.row] ];
        
    } andCompletionBlock:^{
        
        self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
    }];
	// Setting custom popup height
	self.alert.height = 350;
	[self.alert show];
}

// flipside View Controller
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller didFinishEnteringItem:(NSInteger)typeOfLoad startVal:(NSInteger )sV weight:(double)weight;
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        self.typeOfLoad2 = typeOfLoad;
        self.startValue = sV;
        self.weight = weight;
        
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

// settings for the input
- (IBAction)showInfo:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
        
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        if (!self.flipsidePopoverController) {
            FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
            controller.delegate = self;
            self.flipsidePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        }
        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
            
        } else {
            [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

// data View Controller
- (void)dataViewControllerDidFinish:(DataViewController *)controller; {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.dataPopoverController dismissPopoverAnimated:YES];
    }
}

// show the data in a table
- (IBAction)showData:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        DataViewController *controller2 = [[DataViewController alloc] initWithNibName:@"DataViewController" bundle:nil];
        controller2.delegate = self;
        controller2.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller2 animated:YES completion:nil];
    } else {
        if (!self.dataPopoverController) {
            DataViewController *controller2 = [[DataViewController alloc] initWithNibName:@"DataViewController" bundle:nil];
            controller2.delegate = self;
            self.dataPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller2];
        }
        if ([self.dataPopoverController isPopoverVisible]) {
            [self.dataPopoverController dismissPopoverAnimated:YES];
        } else {
            [self.dataPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

// map View Controller
- (void)mapViewControllerDidFinish:(MapViewController *)controller;
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.dataPopoverController dismissPopoverAnimated:YES];
    }
}

// show the place on the map where the pull has been calculated
- (IBAction)showMap:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MapViewController *controller3 = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        controller3.delegate = self;
        controller3.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller3 animated:YES completion:nil];
        
    } else {
        if (!self.mapPopoverController) {
            MapViewController *controller3 = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            controller3.delegate = self;
            self.mapPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller3];
        }
        if ([self.mapPopoverController isPopoverVisible]) {
            [self.mapPopoverController dismissPopoverAnimated:YES];
        } else {
            [self.mapPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
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
