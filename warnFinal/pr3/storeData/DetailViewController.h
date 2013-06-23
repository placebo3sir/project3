//
//  DetailViewController.h
//  storeData
//
//  Created by goblin3 on 5/23/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
