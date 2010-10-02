//
//  TeachingViewController.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 25/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupeUE;
@class UniteEnseignement;
@class ProgressionAlert;

@interface TeachingViewController : UIViewController <UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 
{
    NSArray                     *dataUE;
    NSMutableArray              *searchingDataUE;
    IBOutlet UITableView        *tableView;
	IBOutlet UISearchBar		*searchBarUI;
	GroupeUE					*currentGroup;
	UniteEnseignement			*currentUE;
    NSURLConnection             *EUFeedConnection;
    NSMutableString             *UEString;
    ProgressionAlert            *progressAlert;
    
    BOOL                        searching;
    BOOL                        letUserSelectRow;
    
@private
    UITableViewCell             *currentCell;
}

@property (nonatomic, retain) NSArray                   *dataUE;
@property (nonatomic, retain) NSMutableArray            *searchingDataUE;
@property (nonatomic, retain) GroupeUE                  *currentGroup;
@property (nonatomic, retain) IBOutlet UITableView		*tableView;
@property (nonatomic, retain) IBOutlet UISearchBar		*searchBarUI;
@property (nonatomic, retain) ProgressionAlert          *progressAlert;
@property (nonatomic)         BOOL                      searching;
@property (nonatomic)         BOOL                      letUserSelectRow;

@property (nonatomic, retain) NSURLConnection           *UEFeedConnection;
@property (nonatomic, retain) NSMutableString           *UEString;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end