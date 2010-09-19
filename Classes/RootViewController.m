//
//  RootViewController.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "RootViewController.h"
#import "UniteEnseignements.h"
#import "UniteEnseignement.h"
#import "ParcoursViewController.h"
//#import "UECellView.h"
#import "Constant.h"
#import "Cours.h"
#import "JSON.h"
//#import "DetailViewController.h"

@interface RootViewController ()

- (void)reloadUE:(NSNotification *)note;
- (void)goToSetting;
- (NSString *)getHour:(NSString *)string;
- (NSInteger)getWeekDay:(NSString *)string;

@end

@implementation RootViewController

@synthesize dataCours, coursArray, coursString, coursFeedConnection, emploiDuTemps;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    //Set the array which contain all course.
    self.coursArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //Set the title to the user-visible name of the field
    self.title = @"Calendrier";
    
    //Configure the settings button
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Parcours" style:UIBarButtonItemStyleBordered target:self action:@selector(goToSetting)];
    self.navigationItem.rightBarButtonItem = settingButton;
    [settingButton release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUE:) name:EndSettingsNotification object:nil];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kUM2_INIT]) {
        ParcoursViewController *detailViewController = [[ParcoursViewController alloc] initWithNibName:@"ParcoursViewController" bundle:nil];
		[self presentModalViewController:detailViewController animated:YES];
		[detailViewController release];
    } else {
        [self reloadUE:nil];
    }
}

#pragma mark -
#pragma mark Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.coursString = [NSMutableString string];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [coursString appendString:(str == nil ? @"" : str)];
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
    NSString *json = [coursString stringByReplacingOccurrencesOfString:@"readOnly" 
                                                            withString:@"\"readOnly\""];
    NSLog(@"%@", json);
    self.emploiDuTemps = [json JSONValue];
    self.coursString = nil;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (NSDictionary *UE in emploiDuTemps) {
        Cours *cours = [[[Cours alloc] initWithDictionary:UE] autorelease];
        [self.coursArray addObject:cours];
    }
    [pool release];
    
    [self.tableView reloadData];
    
	NSLog(@"%@", emploiDuTemps);
	NSLog(@"Telechargement des cours fini");
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

#pragma mark -
#pragma mark Privates Methodes

- (void)reloadUE:(NSNotification *)note
{
    
}

- (void)goToSetting
{
    
}

- (NSString *)getHour:(NSString *)string
{
    return (nil);
}

- (NSInteger)getWeekDay:(NSString *)string
{
    return (0);
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
    [self.coursArray release];
}

@end
