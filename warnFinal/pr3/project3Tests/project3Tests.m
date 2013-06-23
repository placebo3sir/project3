//
//  project3Tests.m
//  project3Tests
//
//  Created by Robbert Jaspers on 4/8/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "project3Tests.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"


@implementation project3Tests
@synthesize mvc=_mvc;
@synthesize account=_account;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
       self.account = [[MLTableAlert alloc] init];
    STAssertNotNil(self.account, @"Could not create test subject.");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
   // STFail(@"Unit tests are not implemented yet in project3Tests");
}
@end
