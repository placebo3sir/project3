//
//  DataViewController.m
//  project3
//
//  Created by goblin3 on 5/27/13.
//  Copyright (c) 2013 Osewa. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

@synthesize inputData;

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
                
                // weigth
                char *field5 = (char *) sqlite3_column_text(statement, 4);
                NSString *fieldStr5 = [[NSString alloc] initWithUTF8String:field5];
    
                NSString *str = [[NSString alloc] initWithFormat:@"%@ - %@ - (%@, %@) - %@ kilograms", fieldStr, fieldStr2, fieldStr3, fieldStr4, fieldStr5 ];
    
                [inputData addObject:str];
            }
       }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1; // all objects in 1 view
}

- (NSString *) tableView: (UITableView *) tableView titleForHeaderInSection: (NSInteger)section {
    NSString *tableTitle = [[NSString alloc] initWithFormat:@"Warn History"];
    return tableTitle;
}

- (NSString *) tableView: (UITableView *) tableView titleForFooterInSection: (NSInteger)section {
    NSString *tableTitle = [[NSString alloc] initWithFormat:@" "];
    return tableTitle;
}

- (NSInteger *) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger)section {
    
    return [inputData count];  // return number of rows in sections
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier /*forIndexPath:indexPath*/];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //configure cell
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 10.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text = [self.inputData objectAtIndex:indexPath.row];
    
    return cell;
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
 return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"warn3.sql"];
 }
 
 - (void)openDB {
 if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
     sqlite3_close(db);
     NSAssert(0, @"Could not connect to database");
    }
 }

- (IBAction)deleteAllTableData:(id)sender {
    NSString * tableName = @"WarnHistory";
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"DELETE * FROM %@",
                     tableName];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not clear the requested table");
    } else {
        NSLog(@"The table has been cleared");
    }
}

@end
