//
//  UECellView.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UECellView : UITableViewCell 
{
    IBOutlet UILabel *cours;
    IBOutlet UILabel *type;
    IBOutlet UILabel *heureDebut;
    IBOutlet UILabel *heureFin;
}

@property (nonatomic, assign) IBOutlet UILabel *cours;
@property (nonatomic, assign) IBOutlet UILabel *type;
@property (nonatomic, assign) IBOutlet UILabel *heureDebut;
@property (nonatomic, assign) IBOutlet UILabel *heureFin;

@end
