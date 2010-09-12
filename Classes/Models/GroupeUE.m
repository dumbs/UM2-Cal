//
//  GroupeUE.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "GroupeUE.h"


@implementation GroupeUE

@synthesize lettre, nom, id;

- (void)dealloc {
    self.id = nil;
    self.nom = nil;
    self.lettre = nil;
    [super dealloc];
}

@end
