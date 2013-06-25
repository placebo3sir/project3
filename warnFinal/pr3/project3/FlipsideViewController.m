//
//  FlipsideViewController.m
//  project3
//
//  Created by Osewa on 3/22/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"

@interface FlipsideViewController ()
@end

@implementation FlipsideViewController

@synthesize mvc=_mvc;
@synthesize weight=_weight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// actions
- (IBAction)done:(id)sender {
    self.tOL= typeOfLoad.selectedSegmentIndex;
    self.sV = self.mvc.startValue;
    if(metric.selectedSegmentIndex == 0) {
        self.weight = 1.0;
    } else if(metric.selectedSegmentIndex != 0) {
        self.weight = 2.2046;
    }
    [self.delegate flipsideViewControllerDidFinish:self didFinishEnteringItem:self.tOL startVal:self.sV weight:self.weight];
}

@end
