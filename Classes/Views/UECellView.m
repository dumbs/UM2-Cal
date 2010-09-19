//
//  UECellView.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "UECellView.h"


@implementation UECellView

@synthesize heureDebut, heureFin, cours, type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
