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
- (NSArray *)courseForDay:(NSUInteger)day;
- (NSUInteger)nbOfDifferentDay;
- (NSString *)formatDayToString:(NSInteger)day;
- (void)refresh;

@end

@implementation RootViewController

@synthesize dataCours, coursString, coursArray, daySection, coursFeedConnection, emploiDuTemps, progressAlert;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//Set the title to the user-visible name of the field
	self.title = @"Calendrier";
	
	//Configure the settings button
	UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Parcours" style:UIBarButtonItemStyleBordered target:self action:@selector(goToSetting)];
	self.navigationItem.rightBarButtonItem = settingButton;
	[settingButton release];
    
    //Configure the refresh button
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	self.navigationItem.leftBarButtonItem = refreshButton;
	[refreshButton release];
	
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
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problème de connexion"
													message:[error localizedDescription] 
												   delegate:nil cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *json = [coursString stringByReplacingOccurrencesOfString:@"readOnly" withString:@"\"readOnly\""];
	self.emploiDuTemps = [json JSONValue];
	self.coursString = nil;
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	for (NSDictionary *UE in emploiDuTemps) {
		Cours *cours = [[[Cours alloc] initWithDictionary:UE] autorelease];
		[array addObject:cours];
	}
	[pool release];
    self.coursArray = [NSArray arrayWithArray:array];
    
	[self.tableView reloadData];
    
    [progressAlert dismissProgressionAlert];
    [progressAlert release];
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
    return ([self nbOfDifferentDay]);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ([self formatDayToString:[[daySection objectAtIndex:section] integerValue]]);
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return ([[self courseForDay:[[daySection objectAtIndex:section] integerValue]] count]);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    static NSString *CellIdentifier = @"Cell";
    
    UECellView *cell = (UECellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		UIViewController *cellFactoryViewController = [[UIViewController alloc] initWithNibName:@"Cell" bundle:nil];
		cell = (UECellView *)cellFactoryViewController.view;
		[cell retain];
		[cellFactoryViewController release];
		[cell autorelease];
    }
    
    NSArray *courses = [self courseForDay:[[daySection objectAtIndex:[indexPath section]] integerValue]];
	Cours *cours = [courses objectAtIndex:[indexPath row]];
	cell.cours.text = cours.title;
	cell.heureDebut.text = [self getHour:cours.stringStart];
	cell.heureFin.text = [self getHour:cours.stringEnd];
	cell.type.text = cours.type;
	return (cell);
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
    //Initialisation de l'indicateur de progression.
    progressAlert = [[ProgressionAlert alloc] init];
    [progressAlert createProgressionAlertWithTitle:@"Téléchargement des cours" andMessage: @"Veuillez patienter..."];
    
    //Remise a zero du tableau de section
    self.daySection = nil;
    self.daySection = [NSMutableArray arrayWithCapacity:0];
    
    //Remise a zero du tableau de cours
    self.coursArray = nil;
    self.coursArray = [NSMutableArray arrayWithCapacity:0];
    
    //Recuperation de la date de debut...
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *begin = [outputFormatter stringFromDate:now];
    
    //... et de fin de semaines
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSUndefinedDateComponent fromDate:now];
    [comps setDay:comps.day + 6];
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
    
    NSLog(@"%@", [NSURL URLWithString:[NSString stringWithFormat:kURL_COURS, begin, end, id_parcours, id_groupe]]);
    
	self.coursFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEsURLRequest delegate:self] autorelease];
}

- (void)goToSetting
{
	ParcoursViewController *detailViewController = [[ParcoursViewController alloc] initWithNibName:@"ParcoursViewController" bundle:nil];
	[self presentModalViewController:detailViewController animated:YES];
	[detailViewController release];
}

- (void)refresh
{
    //Initialisation de l'indicateur de progression.
    progressAlert = [[ProgressionAlert alloc] init];
    [progressAlert createProgressionAlertWithTitle:@"Mise à jour des cours" andMessage: @"Veuillez patienter..."];
    
    //Remise a zero du tableau de section
    self.daySection = nil;
    self.daySection = [NSMutableArray arrayWithCapacity:0];
    
    //Remise a zero du tableau de cours
    self.coursArray = nil;
    self.coursArray = [NSMutableArray arrayWithCapacity:0];
    
    //Recuperation de la date de debut...
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *begin = [outputFormatter stringFromDate:now];
    
    //... et de fin de semaines
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSUndefinedDateComponent fromDate:now];
    [comps setDay:comps.day + 6];
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

- (NSArray *)courseForDay:(NSUInteger)day
{
    NSMutableArray *courses = [NSMutableArray arrayWithCapacity:0];

    for (Cours *cours in coursArray) {
        if (cours && ([cours weekDay] == day)) {
            [courses addObject:cours];
        }
    }
    return (courses);
}

- (NSUInteger)nbOfDifferentDay
{
    NSUInteger nb = 0;
    NSInteger day = 0;
    
    for (Cours *cours in self.coursArray) {
        if ([cours weekDay] != day) {
            nb++;
            day = [cours weekDay];
            [daySection addObject:[NSNumber numberWithInteger:day]];
        }
    }
    return (nb);
}

- (NSString *)formatDayToString:(NSInteger)day
{
	switch (day) {
		case 0:
			return @"samedi";
			break;
		case 1:
			return @"dimanche";	
			break;
		case 2:
			return @"lundi";
			break;
		case 3:
			return @"mardi";
			break;
		case 4:	
			return @"mercredi";
			break;
		case 5:
			return @"jeudi";
			break;
		default:	
			return @"vendredi";
			break;
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
    NSArray *courses = [self courseForDay:[[self.daySection objectAtIndex:[indexPath section]] integerValue]];
	Cours *cours = [courses objectAtIndex:[indexPath row]];
	detailViewController.cours = cours;
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

