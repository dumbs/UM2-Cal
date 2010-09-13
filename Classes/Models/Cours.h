//
//  Cours.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//


/*!
    @header Cours
    @abstract Classe permettant de représenter en mémoire un cours.
    @discussion La classe Cours représente un cours. Le cours représente les différentes possibilités,
    pour une UE, d'avoir lieu.
    Les serveurs de la faculté des sciences de Montpellier renvoient des cours sous forme JSON. 
    Cette classe permet de convertir le JSON en interface Objective-C.
    @author Bertrand BRUN
 */

#import <Foundation/Foundation.h>

/*!
    @class      Cours
    @abstract   Cette classe est une représentation mémoire d'un cours.
    @discussion La classe Cours est une classe métier permettant de représenter en mémoire les cours de la fac.
 */
@interface Cours : NSObject 
{
    NSInteger   id;  
    BOOL        allDay; 
    BOOL        editable;   
    BOOL        readOnly;   
    BOOL        model;  
    NSString    *description; 
    NSString    *location;  
    NSString    *title; 
    NSString    *type;  
    NSString    *group; 
    NSDate      *end;   
    NSDate      *start; 
}

/*! @abstract La description du cours. */
@property (nonatomic, retain)               NSString    *description;

/*! @abstract La localisation du cours (e.g. la salle de cours). */
@property (nonatomic, retain)               NSString    *location;

/*! @abstract Le titre du cours. */
@property (nonatomic, retain)               NSString    *title;

/*! @abstract Le type de cours (CM, TD, TP) */
@property (nonatomic, retain)               NSString    *type;

/*! @abstract Le groupe auquel s'adresse ce cours. */
@property (nonatomic, retain)               NSString    *group;

/*! @abstract Permets de savoir si le cours est sur toutes la journée ou non. */
@property (nonatomic, getter = isAllDay)    BOOL        allDay;

/*! @abstract Permets de savoir si le cours est éditable ou non. */
@property (nonatomic, getter = isEditable)  BOOL        editable;

/*! @abstract Permets de savoir si le cours est en lecture seul ou non. */
@property (nonatomic, getter = isReadOnly)  BOOL        readOnly;

/*! @abstract Permets de savoir si le cours est un model ou non. */
@property (nonatomic, getter = isModel)     BOOL        model;

/*! @abstract La date de fin. */
@property (nonatomic, retain)               NSDate      *end;

/*! @abstract La date de debut. */
@property (nonatomic, retain)               NSDate      *start;

/*! @abstract Identifiant du cours. */
@property (nonatomic, assign)               NSInteger   id;

/*! 
 *  @method initWithDictionary:
 *  @abstract Crée un nouveau cours initialisé avec un cours spécifié dans le dictionnaire.
 *  @discussion Le dictionnaire doit contenir tous les champs de la description JSON reçue du
 *  serveur de la fac. Et être converti en dictionnaire par la fonction JSONValue du framework JSON.
 *  @param dictionary Un dictionnaire spécifiant le cours.
 *  @result Un cours initialisee avec le contenu d'un dictionnaire.
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/*! 
 *  @method weekDay
 *  @abstract Permets de récupérer le jour de la semaine du cours.
 *  @discussion Le jour de la semaine est un nombre compris entre 1 et 7. Le 1 représente le dimanche.
 *  @result Un nombre compris entre 1 et 7 représentant le jour où a lieu le cours.
 */
- (NSInteger)weekDay;

@end
