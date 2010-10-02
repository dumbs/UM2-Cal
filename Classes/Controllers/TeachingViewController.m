//
//  TeachingViewController.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 25/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "TeachingViewController.h"
#import "GroupViewController.h"
#import "UniteEnseignements.h"
#import "UniteEnseignement.h"
#import "GroupeUE.h"
#import "Constant.h"
#import "XMLParserUE.h"
#import "ProgressionAlert.h"

@interface TeachingViewController()

- (void)reloadUE:(NSNotification *)note;
- (void)reloadGroup:(NSNotification *)note;
- (void)searchTableView;

@end

@implementation TeachingViewController

@synthesize dataUE, searchBarUI, tableView, currentGroup, UEString, UEFeedConnection, progressAlert, searching, letUserSelectRow, searchingDataUE;

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.dataUE = [[UniteEnseignements allUE] UE];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadUE:)
                                                     name:AllUEDownloadNotification 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadGroup:)
                                                     name:GroupSelectedNotification 
                                                   object:nil];
        
        NSURLRequest *UEURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kURL_PARCOURS]];
        self.UEFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEURLRequest
                                                                 delegate:self] autorelease];
        
        self.searching = NO;
        self.letUserSelectRow = YES;
        self.searchingDataUE = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

    NSString *ident = [[dataUE objectAtIndex:0] id];
    NSInteger row = 0;
    BOOL finding = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:kUM2_INIT]) {
        NSString *UE_ID = [prefs stringForKey:kUE_ID];
        for (UniteEnseignement *UE in self.dataUE) {
            ident = UE.id;
            if ([ident isEqualToString:UE_ID]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                            animated:YES 
                                      scrollPosition:UITableViewScrollPositionMiddle];
                finding = YES;
                break;
            }
            row++;
        }
    }
    currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	currentUE = [dataUE objectAtIndex:(finding ? row : 0)];
}

- (IBAction)save:(id)sender 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
	[prefs setBool:YES forKey:kUM2_INIT];
	if (currentGroup.id)
		[prefs setObject:currentGroup.id forKey:kGROUP_ID];
	else
		[prefs setObject:@"" forKey:kGROUP_ID];
	[prefs setObject:currentUE.id forKey:kUE_ID];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:EndSettingsNotification
                                                        object:nil];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
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
    if (self.searching)
        return ([self.searchingDataUE count]);
    return ([[[UniteEnseignements allUE] UE] count]);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    if (!self.searching) {
        UniteEnseignement *UE = [dataUE objectAtIndex:[indexPath row]];
        cell.textLabel.text = UE.nom;
        cell.detailTextLabel.text = @"Groupe : Tous";
    } else {
        cell.textLabel.text = [[searchingDataUE objectAtIndex:[indexPath row]] nom];
        cell.detailTextLabel.text = @"Groupe : Tous";
    }
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (!self.searching)
        currentUE = [dataUE objectAtIndex:indexPath.row];
    else
        [searchingDataUE objectAtIndex:indexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UniteEnseignement *UE;
    
    if (!self.searching) { 
        UE = [self.dataUE objectAtIndex:[indexPath row]];
        currentUE = UE;
        currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    } else {
        UE = [self.searchingDataUE objectAtIndex:[indexPath row]];
        currentUE = UE;
        currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    }
    // Navigation logic may go here. Create and push another view controller.
    GroupViewController *detailViewController = [[GroupViewController alloc] initWithNibName:@"GroupView" bundle:nil];
    detailViewController.UE = UE;
    // ...
    // Pass the selected object to the new view controller.
    [self presentModalViewController:detailViewController animated:YES];
    [detailViewController release];
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
    [[UniteEnseignements allUE] setUE:UE];
    [xmlParser release];
    [[NSNotificationCenter defaultCenter] postNotificationName:AllUEDownloadNotification object:UE];
    [progressAlert dismissProgressionAlert];
    [progressAlert release];
    NSLog(@"Telechargement des parcours fini");
}

#pragma mark -
#pragma mark search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [self.searchingDataUE removeAllObjects];
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
   
    letUserSelectRow = YES;
    searching = NO;
    self.tableView.scrollEnabled = YES;
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Private Method

- (void)reloadUE:(NSNotification *)note
{    
    self.dataUE = [note object];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableView reloadData];
}


- (void)reloadGroup:(NSNotification *)note
{
    self.currentGroup = [note object];
    currentCell.detailTextLabel.text = [NSString stringWithFormat:@"Groupe : %@", currentGroup.lettre];
    currentCell.selected = YES;
}

- (void) searchTableView
{     
    NSString *searchText = searchBarUI.text;
    
    for (UniteEnseignement *UE in dataUE)
    {
        NSRange titleResultsRange = [UE.nom rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [searchingDataUE addObject:UE];
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
	self.dataUE = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}


@end

