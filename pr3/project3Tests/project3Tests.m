//
//  project3Tests.m
//  project3Tests
//
//  Created by Robbert Jaspers on 4/8/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "project3Tests.h"

@implementation project3Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in project3Tests");
}
- (void)testName {
    NSString *deposit = 1;
    STAssertEqualObjects([person firstName], testFirstName, @"The name does not match");
}
@end
