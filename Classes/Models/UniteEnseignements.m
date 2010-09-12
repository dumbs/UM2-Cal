//
//  UniteEnseignements.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "UniteEnseignements.h"


@implementation UniteEnseignements

@synthesize UE;

#pragma mark -
#pragma mark singleton

static UniteEnseignements *shareUE = nil;

+ (UniteEnseignements *)allUE
{
    if (shareUE == nil) {
        shareUE = [[super allocWithZone:NULL] init];
    }
    return (shareUE);
}

#pragma mark -
#pragma mark Overload

+ (id)allocWithZone:(NSZone *)zone
{
    return ([self allUE]);
}

- (id)copyWithZone:(NSZone *)zone
{
    return (self);
}

- (id)retain
{
    return (self);
}

- (NSUInteger)retainCount
{
    return (NSUIntegerMax); //Désigne un objet qui ne peut être libéré
}

- (void)release
{
    //On ne fait rien
}

- (id)autorelease
{
    return (self);
}

@end
