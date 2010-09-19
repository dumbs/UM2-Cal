//
//  ProgressionAlert.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "ProgressionAlert.h"


@implementation ProgressionAlert

@synthesize progressAlert;

- (void)createProgressionAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
{
    progressAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    [activityView release];
    
    [progressAlert show];
    [progressAlert release];
}

- (void)dismissProgressionAlert
{
    [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc {
    [super dealloc];
}

@end
