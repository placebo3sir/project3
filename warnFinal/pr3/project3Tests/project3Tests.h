//
//  project3Tests.h
//  project3Tests
//
//  Created by Robbert Jaspers on 4/8/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FlipsideViewController.h"
#import "MLTableAlert.h"
#import "Calculator.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@class project3Tests;

@protocol project3TestDelegate
@end

@interface project3Tests : SenTestCase{
    MainViewController *mvc;
    FlipsideViewController *fvc;
    Calculator *cc;
    DataViewController *dvc;
    MapViewController *mapvc;
    
    AppDelegate *appDelegate;
    UINavigationController* mainNavigationController;
}


@end