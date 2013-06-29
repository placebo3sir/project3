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
@class project3Tests;

@protocol project3TestDelegate
- (void)project3TestsDidFinish:(project3Tests *)controller;
@end

@interface project3Tests : SenTestCase

@property (weak, nonatomic) id <project3TestDelegate> delegate;
@end