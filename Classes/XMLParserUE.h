//
//  XMLParserUE.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/*!
    @header XMLParserUE
    @abstract Classe permettant de parser du XML. Le XML parser représente les UE disponibles à la fac.
    @discussion Étant donné que le site de la faculté des sciences de Montpellier renvoie
    les UE sous forme XML, ce parseur est nécessaire pour pouvoir les transformer en objet.
 */

#import <Foundation/Foundation.h>

@class UniteEnseignement;

/*!
    @class      XMLParserUE
    @abstract   Cette classe est un parseur XML.
    @discussion Avec XMLParserUE, on transforme les UE, XML vers un tableau d'UE.
 */
@interface XMLParserUE : NSObject  <NSXMLParserDelegate>
{
    NSMutableArray      *uniteEnseignements;
    UniteEnseignement   *UEEnCours;
@private
    int                 etape;
}

@property (nonatomic, readonly) NSMutableArray *uniteEnseignements;

/*!
    @method parseData:
    @param data Le XML brut récupéré d'internet.
 */
- (void)parseData:(NSData *)data;

@end
