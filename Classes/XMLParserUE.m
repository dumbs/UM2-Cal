//
//  XMLParserUE.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "XMLParserUE.h"
#import "UniteEnseignement.h"

@implementation XMLParserUE

@synthesize uniteEnseignements;

- (void)parseData:(NSData *)data
{
    //Initialisation du parseur XML
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    
    etape = 0;
    
    //Lancement du parseur XML
    [xmlParser parse];
    
    //Vérification des erreurs.
    NSError *parseError = [xmlParser parserError];
    if (parseError) {
        //TODO : On pourrais renvoyer une Execption
        NSLog(@"XMLParser - Error parsing data: %@",[parseError localizedDescription]);
    }
    [xmlParser release];
}

#pragma mark -
#pragma mark Delegate Method

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //On initialise le tableau s'il n'est pas déjà créé
    if (uniteEnseignements == nil)
        uniteEnseignements = [[NSMutableArray alloc] initWithCapacity:0];
    else
        //Sinon on enlève les objets déjà présents
        [uniteEnseignements removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //Si l'élément lu correspond à un objet métier
    if ([elementName isEqualToString:@"row"]) {
        //On crée une instance de l'objet métier et on la stocke
        //dans une variable d'instance.
        UEEnCours = [[UniteEnseignement alloc] init];
        
        //Lecture des attributs de l'élément
        UEEnCours.id = [attributeDict valueForKey:@"id"];
        
        return ;
    }
    
    //Si l'élément lu correspond a cell on avance d'une étape.
    if ([elementName isEqualToString:@"cell"]) {
        etape += 1;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (etape) {
        case 1:
            UEEnCours.code = [string retain];
            etape += 1;
            break;
        case 3:
            UEEnCours.nom = [string retain];
            etape += 1;
            break;
        case 5:
            UEEnCours.composante = [string retain];
            etape += 1;
            break;
        default:
            break;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"row"]) {
        //Le traitement est fini pour cet élément.
        //On ajoute l'objet métier à la liste de tous les objets
        //lu par le parseur.
        [uniteEnseignements addObject:UEEnCours];
        etape = 0;
        [UEEnCours release];
    }
}

- (void)dealloc {
    [uniteEnseignements release];
    [super dealloc];
}

@end
