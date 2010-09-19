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
#import "UECellView.h"
#import "Constant.h"
#import "Cours.h"
#import "JSON.h"
#import "DetailViewController.h"
#import "ProgressionAlert.h"

@interface RootViewController()

- (void)reloadUEs:(NSNotification *)note;
- (void)goToSetting;
- (NSString *)getHour:(NSString *)string;
- (NSInteger)getWeekDay:(NSString *)string;

@end


@implementation RootViewController

@synthesize dataCours, coursString, coursArray, coursFeedConnection, emploiDuTemps, progressAlert;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the array which contain all course
    self.coursArray = [[NSMutableArray alloc] initWithCapacity:0];
    
	//Set the title to the user-visible name of the field
	self.title = @"Calendrier";
	
	//Configure the settings button
	UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Parcours" style:UIBarButtonItemStyleBordered target:self action:@selector(goToSetting)];
	self.navigationItem.rightBarButtonItem = settingButton;
	[settingButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUEs:) name:EndSettingsNotification object:nil];
    
	if (![[NSUserDefaults standardUserDefaults] boolForKey:kUM2_INIT]) {
		ParcoursViewController *detailViewController = [[ParcoursViewController alloc] initWithNibName:@"ParcoursViewController" bundle:nil];
		[self presentModalViewController:detailViewController animated:YES];
		[detailViewController release];
	} else {	
		[self reloadUEs:nil];
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
	if (str != nil) {
		[coursString appendString:str];
	}
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
	NSString *json = [coursString stringByReplacingOccurrencesOfString:@"readOnly" withString:@"\"readOnly\""];
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
    
    [progressAlert dismissProgressionAlert];
    [progressAlert release];
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


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 switch (section) {
 case 0:
 return @"Lundi";
 break;
 case 1:
 return @"Mardi";
 break;
 case 2:
 return @"Mercredi";
 break;
 case 3:
 return @"Jeudi";
 break;
 case 4:	
 return @"Vendredi";
 break;
 case 5:
 return @"Samedi";
 break;
 default:
 return @"Dimanche";		
 break;
 }
 }
 */
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [emploiDuTemps count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UECellView *cell = (UECellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		UIViewController *cellFactoryViewController = [[UIViewController alloc] initWithNibName:@"Cell" bundle:nil];
		cell = (UECellView *)cellFactoryViewController.view;
		[cell retain];
		[cellFactoryViewController release];
		[cell autorelease];
    }
	
	NSDictionary *UE = [emploiDuTemps objectAtIndex:[indexPath row]];
	Cours *cours = [[Cours alloc] initWithDictionary:UE];//[self.coursArray objectAtIndex:[indexPath row]];
	cell.cours.text = cours.title;
	cell.heureDebut.text = [self getHour:[UE objectForKey:@"start"]];
	cell.heureFin.text = [self getHour:[UE objectForKey:@"end"]];
	cell.type.text = cours.type;
	[cours release];
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

#pragma mark -
#pragma mark Privates Methodes

- (void)reloadUEs:(NSNotification *)note;
{
    progressAlert = [[ProgressionAlert alloc] init];
    [progressAlert createProgressionAlertWithTitle:@"Téléchargement des cours" andMessage: @"Veuillez patienter..."];
    
    //Recuperation de la date de debut...
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *begin = [outputFormatter stringFromDate:now];
    
    //... et de fin de semaines
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSUndefinedDateComponent fromDate:now];
    [comps setDay:comps.day + 7];
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *end = [outputFormatter stringFromDate:[gregorian dateFromComponents:comps]];
    
    [gregorian release];
    [outputFormatter release];
    
    //Recuperation du parcours
	NSString *id_parcours = [[NSUserDefaults standardUserDefaults] objectForKey:kUE_ID];
    
    //Recuperation du groupe
	NSString *id_groupe = [[NSUserDefaults standardUserDefaults] objectForKey:kGROUP_ID];
    
    //Envoi de la requete
	NSURLRequest *UEsURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURL_COURS, begin, end, id_parcours, id_groupe]]];    
	self.coursFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEsURLRequest delegate:self] autorelease];
}

- (void)goToSetting
{
	ParcoursViewController *detailViewController = [[ParcoursViewController alloc] initWithNibName:@"ParcoursViewController" bundle:nil];
	[self presentModalViewController:detailViewController animated:YES];
	[detailViewController release];
}

- (NSString *)getHour:(NSString *)string
{
	NSRange rangeOfT = [string rangeOfString:@"T"];
	NSRange range = rangeOfT;
	range.location += 1;
	range.length = 5;
	return ([string substringWithRange:range]);
}

- (NSInteger)getWeekDay:(NSString *)string;
{
	NSRange range = [string rangeOfString:@"T"];
	NSString *dateS = [string substringToIndex:range.location];
	
	NSInteger year = [[dateS substringToIndex:4] intValue];
	range.location = 5;
	range.length = 2;
	NSInteger month = [[dateS substringWithRange:range] intValue];
	range.location = 8;
	range.length = 2;
	NSInteger day = [[dateS substringWithRange:range] intValue];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:day];
	[comps setMonth:month];
	[comps setYear:year];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	[comps release];
	NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:date];
	int weekday = [weekdayComponents weekday];
	[gregorian release];
	return weekday;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	NSDictionary *UE = [emploiDuTemps objectAtIndex:[indexPath row]];
	Cours *cours = [[Cours alloc] initWithDictionary:UE];
	detailViewController.cours = cours;
	[cours release];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [self.coursArray release];
}


@end

