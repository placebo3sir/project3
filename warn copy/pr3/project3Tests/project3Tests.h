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

@class MLTableAlert;

@interface project3Tests : SenTestCase

@property (weak, nonatomic) FlipsideViewController *fvc;
@property (weak, nonatomic) MainViewController *mvc;
@property (strong, nonatomic) MLTableAlert *account;

@end