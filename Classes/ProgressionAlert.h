//
//  ProgressionAlert.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProgressionAlert : NSObject 
{
    UIAlertView     *progressAlert;
}

@property (nonatomic, retain) UIAlertView       *progressAlert;

- (void)createProgressionAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)dismissProgressionAlert;

@end
