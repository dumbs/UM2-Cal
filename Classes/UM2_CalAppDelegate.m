//
//  UM2_CalAppDelegate.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "UM2_CalAppDelegate.h"
#import "RootViewController.h"
#import "XMLParserUE.h"
#import "UniteEnseignement.h"
#import "UniteEnseignements.h"
#import "Constant.h"

NSString    *   AllUEDownloadNotification = @"ALLUEDONWLOAD";
NSString    *   EndSettingsNotification = @"ENDSETTINGS";

@implementation UM2_CalAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize UEFeedConnection, UEString;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //TODO : Juste pour les phases de test    
    [[NSUserDefaults  standardUserDefaults] setBool:NO forKey:kUM2_INIT];
    
    // Override point for customization after application launch.
    NSURLRequest *UEURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kURL_PARCOURS]];
    self.UEFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEURLRequest
                                                             delegate:self] autorelease];
    
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Probleme de connexion"
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
    [[UniteEnseignements allUE] setUE:UE];
    [xmlParser release];
    [[NSNotificationCenter defaultCenter] postNotificationName:AllUEDownloadNotification object:UE];
    NSLog(@"Telechargement des parcours fini");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
