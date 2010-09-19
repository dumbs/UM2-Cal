//
//  DetailViewController.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailView.h"
#import "Cours.h"

@implementation DetailViewController

@synthesize cours;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = @"Cours";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifierDetails = @"Cell";
	static NSString *CellIdentifierDesc = @"CellDesc";
	
	if (indexPath.row == 0) {
		DetailView *cell = (DetailView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierDetails];
		if (cell == nil) {
			UIViewController *cellFactoryViewController = [[UIViewController alloc] initWithNibName:@"CellDetail" bundle:nil];
			cell = (DetailView *)cellFactoryViewController.view;
			[cell retain];
			[cellFactoryViewController release];
			[cell autorelease];
		}
		
		cell.titre.text = cours.title;
		cell.salle.text = cours.location;
		cell.groupe.text = cours.group;
		
		NSCalendar *gregorian = [[NSCalendar alloc]
								 initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSUInteger flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
		
		NSDateComponents *hourStart =
		[gregorian components:flags fromDate:cours.start];
		
		NSDateComponents *hourEnd =
		[gregorian components:flags fromDate:cours.end];
        
		NSInteger hourS = hourStart.hour;
		NSInteger hourE = hourEnd.hour;
		NSInteger minuteS = hourStart.minute;
		NSInteger minuteE = hourEnd.minute;
		NSInteger year = hourStart.year;
		NSInteger month = hourStart.month;
		NSInteger day = hourStart.day;
		NSInteger weekday = hourStart.weekday;
        
		cell.horaire.text = [NSString stringWithFormat:@"de %.2d:%.2d à %.2d:%.2d", hourS, minuteS, hourE, minuteE];
		cell.date.text = [NSString stringWithFormat:@"%@ %d %@ %d", [cours formatDayToString:weekday], day, [cours formatMonthToString:month], year];
		
		[gregorian release];
		
		return cell;
	} else {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierDesc];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellIdentifierDesc] autorelease];
		}
		
		UILabel *label = cell.textLabel;
		label.text = @"Descriptions";
		label.font = [UIFont boldSystemFontOfSize:14];
		
		label = cell.detailTextLabel;
		label.text = [cours description];
		label.lineBreakMode = YES;
		label.numberOfLines = 0;
		label.textColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:1];
		label.font = [UIFont boldSystemFontOfSize:12];
		
		return cell;
	}
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
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:
			return (115);
			break;
		default:
			return (60);
			break;
	}
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
	self.cours = nil;
}


@end