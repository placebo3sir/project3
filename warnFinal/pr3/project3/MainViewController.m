//
//  MainViewController.m
//  project3
//
//  Created by Osewa on 3/22/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "MainViewController.h"
Calculator *cc;

typedef enum {
    info = 0,
    history = 1,
    map = 2
} SelectedButton;


@interface MainViewController ()

@end

#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // create account
    self.account = [[MLTableAlert alloc] init];
    self.weight = 1.0;
    [self show];
    
    cc = [[Calculator alloc] init];
    [cc openDB];
    
        [cc createTable: @"WarnHistory" withField1: @"Date" withField2:@"Pull" withField3:@"Lat" withField4:@"Lon" withField5:@"Weight"];
    
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
    self.infoDisplayLabel5.text = pitch;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// the popup table where users can pick a underground type
-(IBAction)showTableAlert:(id)sender {
    NSMutableArray *load;
    
    if(self.typeOfLoad2 == 0) // 'type of load' = rolling
        load = [NSMutableArray arrayWithObjects: @"Concrete", @"Gravel", @"Dirt", @"Steel rail", nil];
    else // 'type of load' = sliding
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

// show the data in a table
- (IBAction)showView:(id)sender {

    // determine sender button ie info, history, showmap
    UIButton * buttonId = (UIButton * ) sender; // buttonId.tag
    
    NSString *text;
    
    DataViewController *controller;
    FlipsideViewController *controller2;
    MapViewController *controller3;
    
    switch(buttonId.tag)
	{
		case info:{
			text = @"FlipsideViewController";
            controller2 = [[FlipsideViewController alloc] initWithNibName:text bundle:nil];
            controller2.delegate = self;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                controller2.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:controller2 animated:YES completion:nil];
                
            } else {
                if (!self.flipsidePopoverController) {
                    self.flipsidePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller2];
                }
                if ([self.flipsidePopoverController isPopoverVisible]) {
                    [self.flipsidePopoverController dismissPopoverAnimated:YES];
                    
                } else {
                    [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }
			break;
        }
            
		case history:
        {
			text = @"DataViewController";
            controller = [[DataViewController alloc] initWithNibName:text bundle:nil];
            controller.delegate = self;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:controller animated:YES completion:nil];
            } else {
                if (!self.dataPopoverController) {
                    self.dataPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
                }
                if ([self.dataPopoverController isPopoverVisible]) {
                    [self.dataPopoverController dismissPopoverAnimated:YES];
                } else {
                    [self.dataPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }
			break;
        }
            
		case map:// show the place on the map where the pull has been calculated
        {
			text = @"MapViewController";
            controller3 = [[MapViewController alloc] initWithNibName:text bundle:nil];
            controller3.delegate = self;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                controller3.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:controller3 animated:YES completion:nil];
                
            } else {
                if (!self.mapPopoverController) {
                    self.mapPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller3];
                }
                if ([self.mapPopoverController isPopoverVisible]) {
                    [self.mapPopoverController dismissPopoverAnimated:YES];
                } else {
                    [self.mapPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }
			break;
        }
            
	}
    
}

// map View Controller
- (void)mapViewControllerDidFinish:(MapViewController *)controller;
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.mapPopoverController dismissPopoverAnimated:YES];
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

- (void)show {
    // show pull amount
    self.degreeLabel.text = [NSString stringWithFormat:@"%llu °", self.account.degree];
    // show input
    self.calculatePullLabel.text = [NSString stringWithFormat:@"%llu N", self.account.degree2];
}

- (IBAction)callCalculator:(id)sender{
    
    // hide keyboard
    [self.rowsNumField resignFirstResponder];
    
    NSLog(@"Calculating..");
    
    [cc calculatePull:self.rowsNumField result:self.resultLabel startValue:self.startValue weight:self.weight load:self.typeOfLoad2 degreeLabel:self.degreeLabel calculatePullLabel:self.calculatePullLabel]; // call calculator to calculate line pull
}

@end
