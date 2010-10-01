//
//  GroupViewController.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 01/10/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupeUE;
@class UniteEnseignement;

@interface GroupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSArray						*dataGroup;
	GroupeUE					*currentGroup;
    UniteEnseignement           *UE;
    IBOutlet UITableView        *tableView;
    
    NSURLConnection             *UEsGroupFeedConnection;
	NSMutableString             *UEsGroupString;
}

@property (nonatomic, retain) NSArray                   *dataGroup;
@property (nonatomic, retain) GroupeUE                  *currentGroup;
@property (nonatomic, assign) UniteEnseignement         *UE;
@property (nonatomic, retain) IBOutlet UITableView      *tableView;

@property (nonatomic, retain) NSURLConnection           *UEsGroupFeedConnection;
@property (nonatomic, retain) NSMutableString           *UEsGroupString;

- (IBAction)cancel:(id)sender;

@end