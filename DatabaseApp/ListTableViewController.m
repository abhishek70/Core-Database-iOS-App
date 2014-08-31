//
//  ListTableViewController.m
//  DatabaseApp
//
//  Created by Abhishek Desai on 8/7/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import "ListTableViewController.h"


@interface ListTableViewController ()

@end

@implementation ListTableViewController

@synthesize addContactViewController;
@synthesize contactDbUtil;
@synthesize myTableView;
@synthesize contactList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Contact List";
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddContact) ];
    
    self.contactDbUtil = [[ContactDbUtil alloc] init];
    [contactDbUtil initDatabase];
    
    self.contactList = [contactDbUtil getContacts];
    
    /*
     * Code for swiping the rows towards downward to get the latest data.
     */
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor blackColor];
    self.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    //reload the data in the table view
    [self.myTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%lu",(unsigned long)self.contactList.count);
    return [self.contactList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",@"Render cell at a given Index Path Section and Row");
    static NSString *TableViewCellIdentifier = @"MyCells";
    UITableViewCell *myCellView = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (myCellView == nil) {
        myCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        
    }
    
    //get the contact based on the index path section
    Contact *contact = [[Contact alloc] init];
    contact = [self.contactList objectAtIndex:indexPath.row];
    
    //display the employee name in main label of the cell
    myCellView.textLabel.text = [NSString stringWithFormat:@"%@",
                                 contact.name];
    
    //set the accessory view to be a clickable button
    myCellView.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return myCellView;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Contact *contact = [[Contact alloc] init];
    contact = [contactList objectAtIndex:indexPath.row];
    [contactDbUtil deleteContact:contact.Id];
    
    // Remove the row from data model
    [self.contactList removeObjectAtIndex:indexPath.row];
    
    self.contactList = [contactDbUtil getContacts];
    
    // Request table view to reload
    [self.tableView reloadData];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    // *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    NSLog(@"%@",
          [NSString stringWithFormat:@"Cell %ld in Section %ld is selected",
           (long)indexPath.row, (long)indexPath.section]);
    [self editContact:indexPath];
 
}

- (void) editContact:(NSIndexPath *)indexPath
{
    
    //if the edit view controller doesn't exists create it
    if(self.addContactViewController == nil){
        AddContactViewController *editView = [[AddContactViewController alloc] init];
        self.addContactViewController = editView;
    }
    
    //pass the employee id to the edit view controller
    Contact *contact = [[Contact alloc] init];
    contact = [contactList objectAtIndex:indexPath.row];
    [self.addContactViewController setId:contact.Id];
    
    //tell the navigation controller to push a new view into the stack
    [self.navigationController pushViewController:self.addContactViewController animated:YES];
    
}


-(void) AddContact
{
    addContactViewController = [[AddContactViewController alloc] initWithNibName:@"AddContactViewController" bundle:nil];
    [self.addContactViewController setId:0];
    [self.navigationController pushViewController:self.addContactViewController animated:YES];
}

- (void)changeSorting
{
    self.contactList = [contactDbUtil getContacts];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}

@end
