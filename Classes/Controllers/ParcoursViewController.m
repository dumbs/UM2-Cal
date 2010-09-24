//
//  ParcoursViewController.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 19/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "ParcoursViewController.h"
#import "UniteEnseignements.h"
#import "UniteEnseignement.h"
#import "GroupeUE.h"
#import "XMLParserGroupeUE.h"
#import "Constant.h"

@interface ParcoursViewController()

- (void)reloadUE:(NSNotification *)note;

@end

@implementation ParcoursViewController

@synthesize dataUE, dataGroup, picker, table, searchBar, currentCell, UEsGroupFeedConnection, UEsGroupString;
@synthesize currentGroup, currentUE;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.dataUE = [[UniteEnseignements allUE] UE];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadUE:)
                                                     name:AllUEDownloadNotification 
                                                   object:nil];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)save
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

- (IBAction)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)reloadUE:(NSNotification *)note
{
    self.dataUE = [note object];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    currentCell = [table cellForRowAtIndexPath:indexPath];
    [table reloadData];
    
    UniteEnseignement *UE = [dataUE objectAtIndex:0];
    currentCell.textLabel.text = UE.nom;
    
    NSString *ident = [[dataUE objectAtIndex:0] id];
    int i_time = time(NULL);
    
    NSURLRequest *UEURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURL_GROUP, ident, i_time]]];
    self.UEsGroupFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEURLRequest delegate:self] autorelease];
    [picker reloadAllComponents];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	UniteEnseignement *UE = [dataUE objectAtIndex:[indexPath row]];
	cell.textLabel.text = (UE.nom ? UE.nom : @"En Attente...");
	cell.detailTextLabel.text = @"Groupe : Tous";
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentCell = [tableView cellForRowAtIndexPath:indexPath];
    [picker reloadComponent:1];
}

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
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	XMLParserGroupeUE *xmlParser = [[XMLParserGroupeUE alloc] init];
	[xmlParser parseData:[UEsGroupString dataUsingEncoding:NSUTF8StringEncoding]];
	self.dataGroup = xmlParser.groupeUE;
	[xmlParser release];
	[picker reloadComponent:1];
	if (currentGroup == nil) {
		NSInteger row = 0;
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		if ([prefs boolForKey:kUM2_INIT]) {
			NSString *Group_ID = [prefs stringForKey:kGROUP_ID];
			for (GroupeUE *groupe in dataGroup) {
				if ([groupe.id isEqualToString:Group_ID]) {
					[picker selectRow:row inComponent:1 animated:YES];
					break;
				}
				row++;
			}
		}
	}
	NSLog(@"Telechargment des groupes fini");
}

#pragma mark -
#pragma mark Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return (2);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return ([dataUE count]);
        default:
            return ([dataGroup count]);
    }
}

#pragma mark -
#pragma mark Picker view delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return (self.view.frame.size.width * 0.65);
        default:
            return (self.view.frame.size.width * 0.35);
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            currentUE = [dataUE objectAtIndex:row];
            self.currentCell.textLabel.text = [[dataUE objectAtIndex:row] nom];
            NSString *ident = [[dataUE objectAtIndex:row] id];
            int i_time = time(NULL);
            NSURLRequest *UEURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURL_GROUP, ident, i_time]]];
            self.UEsGroupFeedConnection = [[[NSURLConnection alloc] initWithRequest:UEURLRequest delegate:self] autorelease];
            break;
        default:
            self.currentCell.detailTextLabel.text = [NSString stringWithFormat:@"Groupe : %@", [[dataGroup objectAtIndex:row] lettre]];
            currentGroup = [dataGroup objectAtIndex:row];
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return ([[dataUE objectAtIndex:row] nom]);
        default:
            return ([[dataGroup objectAtIndex:row] lettre]);
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	self.table = nil;
	self.dataUE = nil;
	self.picker = nil;
	NSLog(@"Destruction de Parcours");
}


@end
