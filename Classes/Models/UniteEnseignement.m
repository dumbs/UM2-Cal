//
//  UniteEnseignement.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "UniteEnseignement.h"


@implementation UniteEnseignement

@synthesize nom, id, composante, code;

- (void)dealloc {
    self.nom = nil;
    self.id = nil;
    self.composante = nil;
    self.code = nil;
    [super dealloc];
}

@end
