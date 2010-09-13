//
//  XMLParserGroupeUE.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 13/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "XMLParserGroupeUE.h"
#import "GroupeUE.h"

@implementation XMLParserGroupeUE

@synthesize groupeUE;

- (void)parseData:(NSData *)data
{
	//Initialisation du parseur XML
	NSXMLParser	*xmlParser = [[NSXMLParser alloc] initWithData:data];
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
		NSLog(@"XMLParser - Error parsing data: %@", [parseError localizedDescription]);
	}
	[xmlParser release];
}

#pragma mark -
#pragma mark Delegate Methode

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //On initialise le groupe d'UE avec un objet par défaut qui est 
    //tout les groupes.
	if (groupeUEs == nil) {
		GroupeUE *all = [GroupeUE new];
		all.nom = @"Tous les groupes";
		all.lettre = @"Tous";
		all.id = nil;
		groupeUEs = [[NSMutableArray alloc] initWithObjects:all, nil];
		[all release];
	}
	else
		[groupeUEs removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict 
{
	//Si l'élément lu correspond à un objet métier
	if ([elementName isEqualToString:@"row"]) {
		//On crée une instance de l'objet métier et on la stocke
		//dans une variable d'instance
		currentGroupe = [[GroupeUE alloc] init];
		
		//Lecture des attributs de l'élément
		NSString *ident = [attributeDict valueForKey:@"id"];
		NSRange range = [ident rangeOfString:@","];
		currentGroupe.id = [ident substringFromIndex:range.location + 1];
		return;
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
			currentGroupe.nom = [string retain];
			etape += 1;
			break;
		case 3:
			currentGroupe.lettre = [string retain];
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
		[groupeUEs addObject:currentGroupe];
		etape = 0;
		[currentGroupe release];
	}
}

- (void) dealloc
{
	[groupeUEs release];
	[super dealloc];
}

@end
