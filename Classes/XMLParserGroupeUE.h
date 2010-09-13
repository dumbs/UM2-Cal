//
//  XMLParserGroupeUE.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 13/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/*!
    @header XMLParserUE
    @abstract Classe permettant de parser du XML. Le XML parser représente les groupes pour une EU
    disponibles à la fac.
    @discussion Étant donné que le site de la faculté des sciences de Montpellier renvoie
    les groupe d'UE sous forme XML, ce parseur est nécessaire pour pouvoir les transformer en objet.
 */

#import <Foundation/Foundation.h>

@class GroupeUE;

/*!
    @class      XMLParserGroupeUE
    @abstract   Cette classe est un parseur XML.
    @discussion Avec XMLParserGroupeUE, on transforme les groupe d'UE en XML vers un tableau de 
    groupe d'UE.
 */
@interface XMLParserGroupeUE : NSObject <NSXMLParserDelegate>
{
    NSMutableArray  *groupeUE;
    GroupeUE        *groupeEnCours;
@private
    int             etape;
}

@property (readonly) NSMutableArray *groupeUE;

/*!
 @method parseData:
 @param data Le XML brut récupéré d'internet.
 */
- (void)parseData:(NSData *)data;

@end
