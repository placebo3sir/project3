//
//  MapViewController.h
//  project3
//
//  Created by goblin3 on 5/27/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "sqlite3.h"

@class MapViewController;

@protocol MapViewControllerDelegate
- (void)dataViewControllerDidFinish:(MapViewController *)controller;
@end

@interface MapViewController : UIViewController<MKAnnotation>{
    sqlite3 *db;
}

@property (weak, nonatomic) id <MapViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *inputData;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) NSString* title2;
@property (nonatomic, readwrite) NSString* subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)done:(id)sender;
- (NSString *) filePath;
- (void) openDB;
@end
