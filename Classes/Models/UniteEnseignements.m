//
//  UniteEnseignements.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "UniteEnseignements.h"
#import "XMLParserUE.h"
#import "Constant.h"
#import "ProgressionAlert.h"


@implementation UniteEnseignements

@synthesize UEString, UEFeedConnection, progressAlert, UEs;

#pragma mark -
#pragma mark singleton

static UniteEnseignements *shareUE = nil;

+ (UniteEnseignements *)allUE
{
    if (shareUE == nil) {
        shareUE = [[super allocWithZone:NULL] init];
    }
    return (shareUE);
}

#pragma mark -
#pragma mark Overload

+ (id)allocWithZone:(NSZone *)zone
{
    return ([self allUE]);
}

- (id)copyWithZone:(NSZone *)zone
{
    return (self);
}

- (id)retain
{
    return (self);
}

- (NSUInteger)retainCount
{
    return (NSUIntegerMax); //Désigne un objet qui ne peut être libéré
}

- (void)release
{
    //On ne fait rien
}

- (id)autorelease
{
    return (self);
}

- (id)init {
    if ((self = [super init])) {
        NSURLRequest *UEURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kURL_PARCOURS]];
        self.UEFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEURLRequest
                                                                 delegate:self] autorelease];
    }
    return self;
}

#pragma mark -
#pragma mark Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    progressAlert = [[ProgressionAlert alloc] init];
    [progressAlert createProgressionAlertWithTitle:@"Téléchargement des Parcours" andMessage: @"Veuillez patienter..."];
    
    self.UEString = [NSMutableString string];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [UEString appendString:(str == nil ? @"" : str)];
    [str release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problème de connexion"
													message:[error localizedDescription] 
												   delegate:nil cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    XMLParserUE *xmlParser = [[XMLParserUE alloc] init];
    [xmlParser parseData:[UEString dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *UE = xmlParser.uniteEnseignements;
    [[UniteEnseignements allUE] setUEs:UE];
    [xmlParser release];
    [[NSNotificationCenter defaultCenter] postNotificationName:AllUEDownloadNotification object:UE];
    [progressAlert dismissProgressionAlert];
    [progressAlert release];
    NSLog(@"Telechargement des parcours fini");
}

@end
