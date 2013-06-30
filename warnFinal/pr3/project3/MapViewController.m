//
//  MapViewController.m
//  project3
//
//  Created by goblin3 on 5/27/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//  openDB, filePath, done similar to Calculator, to allow moving

#import "MapViewController.h"

@interface MapViewController ()

@end
#define METERS_PER_MILE  1609.33
#define LAT_NETHERLANDS 52.30
#define LON_NETHERLANDS 5.54

@implementation MapViewController
@synthesize inputData;
@synthesize coordinate;
@synthesize title2;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
{
    self = [super init];
    if (self) {
        coordinate = location;
        title2 = placeName;
        subtitle = description;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    }
    return self;
}

- (void)viewDidLoad {
    inputData = [[NSMutableArray alloc] init];
    [self openDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM WarnHistory"];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            // pull
            char *field1 = (char *) sqlite3_column_text(statement, 0);
            NSString *fieldStr = [[NSString alloc] initWithUTF8String:field1];
            
            // date
            char *field2 = (char *) sqlite3_column_text(statement, 1);
            NSString *fieldStr2 = [[NSString alloc] initWithUTF8String:field2];
            
            // location lat
            char *field3 = (char *) sqlite3_column_text(statement, 2);
            NSString *fieldStr3 = [[NSString alloc] initWithUTF8String:field3];

            // lon
            char *field4 = (char *) sqlite3_column_text(statement, 3);
            NSString *fieldStr4 = [[NSString alloc] initWithUTF8String:field4];

            
            NSString *str = [[NSString alloc] initWithFormat:@"%@ - %@ - (%@, %@)", fieldStr, fieldStr2, fieldStr3, fieldStr4 ];
            
            coordinate = CLLocationCoordinate2DMake([fieldStr3 integerValue],
                                                                          [fieldStr4 integerValue]);
            
            MapViewController* pinAnnotation =
            [[MapViewController alloc] initWithCoordinates:coordinate
                                                placeName:nil
                                              description:fieldStr];
            [_mapView addAnnotation:pinAnnotation];
            [inputData addObject:str];
        }
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.delegate dataViewControllerDidFinish:self];
}

- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"warn4.sql"];
}

- (void)openDB {
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not connect to database");
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString* myIdentifier = @"myIndentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
    } else {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
    }
    return pinView;
}

@end
