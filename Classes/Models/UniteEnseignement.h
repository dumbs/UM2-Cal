//
//  UniteEnseignement.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/*!
    @header UniteEnseignement
    @abstract Cette classe représente une unité d'enseignement (UE).
    @discussion Une UE est une matière et non un cours. Une UE sert 
    à décrire une matière, là où le cours est enseigné. Cette classe
    permet de représenter une UE en machine. Cette représentation est
    celle que renvoie la faculté des sciences de Montpellier en JSON.
    @author Bertrand BRUN
 */

#import <Foundation/Foundation.h>

/*!
    @class      UniteEnseignement
    @abstract   Cette classe est une représentation mémoire d'une UE.
    @discussion La classe UniteEnseignement est une classe métier permettant
    de représenter en mémoire les différentes UE proposées par la fac.
 */
@interface UniteEnseignement : NSObject 
{
    NSString    *id;
    NSString    *code;
    NSString    *nom;
    NSString    *composante;
}

/*! @abstract Est l'identifiant de l'UE */
@property (nonatomic, retain) NSString *id;

/*! @abstract Est le code de l'UE */
@property (nonatomic, retain) NSString *code;

/*! @abstract Est le nom de l'UE */
@property (nonatomic, retain) NSString *nom;

/*! @abstract Est la composante de l'UE */
@property (nonatomic, retain) NSString *composante;

@end
