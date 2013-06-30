//
//  project3Tests.m
//  project3Tests
//
//  Created by Robbert Jaspers on 4/8/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "project3Tests.h"
#import "Calculator.h"

@implementation project3Tests

- (void)setUp
{
    [super setUp];

    mainNavigationController = (UINavigationController*)appDelegate.window.rootViewController;
    mvc = (MainViewController*)mainNavigationController.visibleViewController;
}


- (void)tearDown
{
    
    [super tearDown];
}

- (void)testmainViewController {
    //STAssertTrue([mvc isMemberOfClass:[MainViewController class]], @"");
    UIButton* nextButton = (UIButton*)[mvc.view viewWithTag:3];
    [nextButton sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    STAssertTrue(mainNavigationController.visibleViewController == mvc, @"empty input check did not work"); //should not calculate as textfield is empty
    
}
@end
