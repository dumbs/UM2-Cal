//
//  UM2_CalAppDelegate.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/**
 @mainpage UM2 Cal une application iPhone pour consulter le calendrier de la faculté des sciences de Montpellier.
 
 Après avoir constaté que l'utilisation de <a href="http://edt.ufr.univ-montp2.fr/">l'emploi du temps</a> de la fac n'est pas facile à utiliser, voir même impossible depuis un iPhone. J’ai alors décidé de créer une application permettant de le consulter.
  
 @section Fonctionnalités
 
 @li Facile à utiliser.
 @li Permets de récupérer tous les parcours.
 @li Possibilité d'avoir l'emploi d'une UE plutôt que d'un parcours.
 
 
 @section Lien
 
 @li Récupère <a href="http://github.com/dumbs/UM2-Cal">les sources sur github</a>.
 
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
