//
//  DetailView.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailView : UITableViewCell 
{
    IBOutlet UILabel *titre;
    IBOutlet UILabel *salle;
    IBOutlet UILabel *groupe;
    IBOutlet UILabel *date;
    IBOutlet UILabel *horaire;
}

@property (nonatomic, retain) IBOutlet UILabel *titre;
@property (nonatomic, retain) IBOutlet UILabel *salle;
@property (nonatomic, retain) IBOutlet UILabel *horaire;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *groupe;

@end
