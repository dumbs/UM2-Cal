//
//  UM2_CalAppDelegate.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/**
 @mainpage UM2 Cal une application iPhone pour consulter le calendrier de la facult� des sciences de Montpellier.
 
 Apr�s avoir constat� que l'utilisation de <a href="http://edt.ufr.univ-montp2.fr/">l'emploi du temps</a> de la fac n'est pas facile � utiliser, voir m�me impossible depuis un iPhone. J�ai alors d�cid� de cr�er une application permettant de le consulter.
  
 @section Fonctionnalit�s
 
 @li Facile � utiliser.
 @li Permets de r�cup�rer tous les parcours.
 @li Possibilit� d'avoir l'emploi d'une UE plut�t que d'un parcours.
 
 
 @section Lien
 
 @li R�cup�re <a href="http://github.com/dumbs/UM2-Cal">les sources sur github</a>.
 
 */

#import <UIKit/UIKit.h>

@interface UM2_CalAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow                *window;
    UINavigationController  *navigationController;
    NSURLConnection         *EUFeedConnection;
    NSMutableString         *UEString;
}

@property (nonatomic, retain) IBOutlet UIWindow                 *window;
@property (nonatomic, retain) IBOutlet UINavigationController   *navigationController;

@property (nonatomic, retain) NSURLConnection                   *UEFeedConnection;
@property (nonatomic, retain) NSMutableString                   *UEString;

@end
