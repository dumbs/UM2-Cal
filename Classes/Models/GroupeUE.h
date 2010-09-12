//
//  GroupeUE.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/*!
    @header GroupeUE
    @abstract   Classe permettant de représenter en mémoire les groupes pour les UE.
	@discussion La Classe GroupeUE est une représentation mémoire d'un groupe pour une UE
    donnée. Une UE (ou un cours) peut avoir plusieurs groupes associer. Cette classe ne s'en 
    occupe pas. Elle ne sert qu'à stocker en mémoire ce que nous renvoie le serveur au 
    format JSON.
	@author Bertrand BRUN
*/


#import <Foundation/Foundation.h>

/*!
    @class
    @abstract    La classe GroupeUE représente un groupe pour une UE.
	@discussion  À la faculté des sciences de Montpellier, les étudiants inscrits dans une UE sont 
 réparties en groupe. Cette classe permet de représenter ces groupes.
*/
@interface GroupeUE : NSObject 
{
    NSString    *id;
    NSString    *nom;
    NSString    *lettre;
}

/*! @abstract L'identifiant du groupe 
	@discussion L'identifiant est généré au niveau de la faculté.
 */
@property (nonatomic, retain) NSString  *id;

/*! @abstract Le nom du groupe. 
	@discussion Le nom du groupe est donnée par la faculté.
 */
@property (nonatomic, retain) NSString  *nom;

/*! @abstract La lettre attribue au groupe. 
 @discussion La lettre du groupe est donnée par la faculté.
 */
@property (nonatomic, retain) NSString  *lettre;

@end
