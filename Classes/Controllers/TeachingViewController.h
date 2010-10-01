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

@interface TeachingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 
{
    NSArray                     *dataUE;
    IBOutlet UITableView        *tableView;
	IBOutlet UISearchBar		*searchBar;
	GroupeUE					*currentGroup;
	UniteEnseignement			*currentUE;
}

@property (nonatomic, retain) NSArray                   *dataUE;
@property (nonatomic, retain) IBOutlet UITableView		*tableView;
@property (nonatomic, retain) IBOutlet UISearchBar		*searchBar;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end