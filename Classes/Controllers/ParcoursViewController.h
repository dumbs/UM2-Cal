//
//  ParcoursViewController.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupeUE;
@class UniteEnseignement;

@interface ParcoursViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray						*dataUE;
	NSArray						*dataGroup;
	IBOutlet UIPickerView		*picker;
	IBOutlet UITableView		*table;
	IBOutlet UISearchBar		*searchBar;
	UITableViewCell				*currentCell;
	GroupeUE					*currentGroup;
	UniteEnseignement			*currentUE;
	
	NSURLConnection             *UEsGroupFeedConnection;
	NSMutableString             *UEsGroupString;
}

@property (nonatomic, retain) NSArray                   *dataUE;
@property (nonatomic, retain) NSArray                   *dataGroup;
@property (nonatomic, retain) GroupeUE                  *currentGroup;
@property (nonatomic, retain) UniteEnseignement			*currentUE;
@property (nonatomic, retain) UITableViewCell			*currentCell;
@property (nonatomic, retain) IBOutlet UIPickerView		*picker;
@property (nonatomic, retain) IBOutlet UITableView		*table;
@property (nonatomic, retain) IBOutlet UISearchBar		*searchBar;

@property (nonatomic, retain) NSURLConnection           *UEsGroupFeedConnection;
@property (nonatomic, retain) NSMutableString           *UEsGroupString;

- (IBAction)save;
- (IBAction)cancel;

@end