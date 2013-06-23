//
//  FlipsideViewController.h
//  project3
//
//  Created by Osewa on 3/22/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;
@class MainViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller didFinishEnteringItem:(NSInteger)typeOfLoad startVal:(NSInteger )sV weight:(double)weight;
@end

@interface FlipsideViewController : UIViewController{
    IBOutlet UISegmentedControl *typeOfLoad;
    IBOutlet UISegmentedControl *metric;
}

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) MainViewController *mvc;
@property (assign, nonatomic) unsigned long long tOL;
@property (assign, nonatomic) NSInteger sV;
@property (assign, nonatomic) double weight;

- (IBAction)done:(id)sender;
- (IBAction)load:(id)sender;
- (IBAction)metric:(id)sender;
- (IBAction)historyLayout:(id)sender;
@end
