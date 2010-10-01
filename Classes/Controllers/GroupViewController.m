//
//  GroupViewController.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 01/10/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "GroupViewController.h"
#import "UniteEnseignement.h"
#import "GroupeUE.h"
#import "XMLParserGroupeUE.h"
#import "Constant.h"


@implementation GroupViewController

@synthesize dataGroup, currentGroup, UEsGroupFeedConnection, UEsGroupString, UE, tableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    currentGroup = nil;
    int i_time = time(NULL);
    NSURLRequest *UEsURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURL_GROUP, UE.id, i_time]]];
    self.UEsGroupFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEsURLRequest delegate:self] autorelease];
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

- (IBAction)cancel:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataGroup count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    GroupeUE *groupe = [self.dataGroup objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"Groupe : %@", groupe.lettre];;
    
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
#pragma mark Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.UEsGroupString = [NSMutableString string];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[UEsGroupString appendString:str];
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
    XMLParserGroupeUE *xmlParser = [[XMLParserGroupeUE alloc] init];
	[xmlParser parseData:[UEsGroupString dataUsingEncoding:NSUTF8StringEncoding]];
	self.dataGroup = xmlParser.groupeUE;
	[xmlParser release];
    
    [self.tableView reloadData];

	NSLog(@"Telechargment des groupes fini");
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GroupSelectedNotification 
                                                        object:[self.dataGroup objectAtIndex:[indexPath row]]];
    [self dismissModalViewControllerAnimated:YES];
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
    self.tableView = nil;
}


- (void)dealloc {
    [super dealloc];/*
    self.dataGroup = nil;
	self.currentGroup = nil;
    self.tableView = nil;
    
	self.UEsGroupString = nil;*/
}


@end

