//
//  RootViewController.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgressionAlert;

@interface RootViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate>
{
    NSURLConnection     *coursFeedConnection;
    NSMutableString     *coursString;
    NSArray             *emploiDuTemps;
    NSArray             *dataCours;
    NSArray             *coursArray;
    ProgressionAlert    *progressAlert;
    NSMutableArray      *daySection;
    
}

@property (nonatomic, retain) NSArray           *emploiDuTemps;
@property (nonatomic, retain) NSArray           *dataCours;
@property (nonatomic, retain) NSArray           *coursArray;
@property (nonatomic, retain) NSMutableArray    *daySection;
@property (nonatomic, retain) NSURLConnection   *coursFeedConnection;
@property (nonatomic, retain) NSMutableString   *coursString;
@property (nonatomic, retain) ProgressionAlert  *progressAlert;

@end
