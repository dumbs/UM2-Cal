//
//  UniteEnseignements.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/*!
    @header UniteEnseignement
    @abstract   Cette classe est un singleton, et permet de garder en mémoire toutes les UE.
    @discussion Comme l'application doit tourner sur un mobile, la consommation
    d'énergie est à surveiller. Cette classe permet de ne pas avoir à télécharger
    tout le temps les UE, ce qui permet une économie d'énergie, du fait de la grande
    consommation d'énergie du réseau.
 */

#import <Foundation/Foundation.h>

@class ProgressionAlert;

/*!
    @class      UniteEnseignements
    @abstract   La classe UniteEnseignement est un singleton.
    @discussion Pour économiser les accès à internet qui sont gourmands en énergie,
    cette classe garde une fois téléchargées toutes les UE de la faculté des sciences
    de Montpellier.
 */
@interface UniteEnseignements : NSObject <UIApplicationDelegate>
{
    NSArray                     *UEs;
    NSURLConnection             *EUFeedConnection;
    NSMutableString             *UEString;
    ProgressionAlert            *progressAlert;
}

@property (nonatomic, retain, getter = UE) NSArray      *UEs;
@property (nonatomic, retain) ProgressionAlert          *progressAlert;

@property (nonatomic, retain) NSURLConnection           *UEFeedConnection;
@property (nonatomic, retain) NSMutableString           *UEString;

/*! 
    @method allUE
    @abstract Retourne un objet représentant toutes les UE de la fac.
    @result Un objet singleton représentant toutes les UE de la fac.
 */
+ (UniteEnseignements *)allUE;

@end
