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

@interface TeachingViewController()

- (void)reloadUE:(NSNotification *)note;
- (void)reloadGroup:(NSNotification *)note;

@end

@implementation TeachingViewController

@synthesize dataUE, searchBar, tableView, currentGroup;

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
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

    NSString *ident = [[dataUE objectAtIndex:0] id];
    NSInteger row = 0;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:kUM2_INIT]) {
        NSString *UE_ID = [prefs stringForKey:kUE_ID];
        for (UniteEnseignement *UE in self.dataUE) {
            ident = UE.id;
            if ([ident isEqualToString:UE_ID]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                            animated:YES 
                                      scrollPosition:UITableViewScrollPositionMiddle];
                break;
            }
            row++;
        }
    }
    currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	currentUE = [dataUE objectAtIndex:row];
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
	
	[[NSNotificationCenter defaultCenter] postNotificationName:EndSettingsNotification object:nil];
	
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
    return [[[UniteEnseignements allUE] UE] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    UniteEnseignement *UE = [dataUE objectAtIndex:[indexPath row]];
	cell.textLabel.text = UE.nom;
	cell.detailTextLabel.text = @"Groupe : Tous";
    
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
    currentUE = [dataUE objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UniteEnseignement *UE = [self.dataUE objectAtIndex:[indexPath row]];
    currentUE = [dataUE objectAtIndex:indexPath.row];
    currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Navigation logic may go here. Create and push another view controller.
    GroupViewController *detailViewController = [[GroupViewController alloc] initWithNibName:@"GroupView" bundle:nil];
    detailViewController.UE = UE;
    // ...
    // Pass the selected object to the new view controller.
    [self presentModalViewController:detailViewController animated:YES];
    [detailViewController release];
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

