//
//  Constant.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

/*!
    @header Constant
    @abstract   Ce header regroupe toutes les constantes.
	@discussion Pour ce projet, toutes les constantes sont regroupées dans ce fichier.
    Par constante, on entend toutes les variables globales, ainsi que tout les #define.
*/


#ifndef CONSTANT_H_
#   define CONSTANT_H_

/*!
    @const      AllUEDownloadNotification
    @abstract   Permets de notifier que le programme a fini de télécharger toutes les UE.
	@discussion Lors du lancement de l'application, toutes les UE se téléchargent. Lorsque ce téléchargement
    est fini, l'application le notifie par cette constante.
*/
extern NSString *   AllUEDownloadNotification;


/*!
 @const         EndSettingsNotification
 @abstract      Permets de notifier que l'utilisateur a fini de choisir son parcours.
 @discussion    Lorsque l'utilisateur quitte le panneau parcours, l'application le notifie par cette constante
 */
extern NSString *   EndSettingsNotification;

/*!
    @defined    kURL_GROUP
    @abstract   URL de récupération des groupes.
	@discussion Lorsque l'on veut récupérer les groupes pour une UE choisie, il faut envoyer au serveur de la
    fac cette define.
*/

#define kURL_GROUP      @"http://edt.ufr.univ-montp2.fr/4DAction/AJAX_EtpSubGrid?id=%@&_search=false&nd=%u&rows=-"

/*!
 @defined       kURL_PARCOURS
 @abstract      URL de récupération des parcours.
 @discussion    Lorsque l'on veut récupérer les parcours proposés par la fac, il faut envoyer cette define.
 */
#define kURL_PARCOURS   @"http://edt.ufr.univ-montp2.fr/4DAction/AJAX_EtpGrid?_search=false&nd=1275562098299&rows=-1&page=1&sidx=Lib&sord=asc"

/*!
 @defined       kURL_COURS
 @abstract      URL de récupération des cours.
 @discussion    Lorsque l'on veut récupérer les cours pour un parcours donné, il faut envoyer cette define.
 */
#define kURL_COURS      @"http://edt.ufr.univ-montp2.fr/4DAction/AJAX_Occ?start=%@&end=%@&sel=Etp%%3A+%@"

#define kUM2_INIT       @"UM2_INIT" //BOOL
#define kUE_ID          @"UE_ID"    //String
#define kGROUP_ID       @"GROUP_ID" //String

#endif  /*! CONSTANT_H_ */