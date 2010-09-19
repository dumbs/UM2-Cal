//
//  DetailViewController.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cours;

@interface DetailViewController : UITableViewController <UITableViewDelegate>
{
    Cours   *cours;
}

@property (nonatomic, retain) Cours *cours;

@end
