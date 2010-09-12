//
//  Constant.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#ifndef CONSTANT_H_
#   define CONSTANT_H_

extern NSString *   AllUEDownloadNotification;
extern NSString *   EndSettingsNotification;

#define kURL_GROUP      @"http://edt.ufr.univ-montp2.fr/4DAction/AJAX_EtpSubGrid?id=%@&_search=false&nd=%u&rows=-"
#define kURL_PARCOURS   @"http://edt.ufr.univ-montp2.fr/4DAction/AJAX_EtpGrid?_search=false&nd=1275562098299&rows=-1&page=1&sidx=Lib&sord=asc"
#define kURL_COURS      @"http://edt.ufr.univ-montp2.fr/4DAction/AJAX_Occ?start=%@&end=%@&sel=Etp%%3A+%@"

#define kUM2_INIT       @"UM2_INIT" //BOOL
#define kUE_ID          @"UE_ID"    //String
#define kGROUP_ID       @"GROUP_ID" //String

#endif  /*! CONSTANT_H_ */