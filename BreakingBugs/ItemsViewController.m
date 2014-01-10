//
//  ItemsViewController.m
//  BreakingBugs
//
//  Created by Marin Fischer on 12/10/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "ItemsViewController.h"
#import "BugItemStore.h"
#import "BugItem.h"

@implementation ItemsViewController

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Breaking Bugs"];
        
        //Create a new bar button item that will send addNewItem: to ItemsViewController
        UIBarButtonItem *addNewBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(addNewItem:)];
        
        //Set this bar button item as the right item in  the navigationItem
        [[self navigationItem] setRightBarButtonItem:addNewBBI];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

//This will ensure that all instances of ItemsViewController use the UITableViewStyleGrouped style, no matter what initialization message is sent to it.
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"BugItemCell" bundle:nil];
    
    //Register the NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BugItemCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BugItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set the text on the cell with the description of the item that is at the nth index of items, where n=row this cell will appear in on the tableview
    BugItem *p = [[[BugItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    //Get the new or recycled cell
    BugItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BugItemCell"];
    
    //Configure the cell with the BugItem
    [[cell nameLabel] setText:[p itemName]];
    [[cell bugNumberLabel] setText:[p bugNumber]];
    [[cell priorityLabel] setText:[NSString stringWithFormat:@"%d", [p priorityRating]]];
    
    [[cell thumbnailView] setImage:[p thumbnail]];
    
    return cell;
}

- (IBAction)addNewItem:(id)sender
{
    //Create a new BugItem and add  it to the store
    BugItem *newItem = [[BugItemStore  sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{ [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BugItemStore *ps = [BugItemStore sharedStore];
        NSArray *items = [ps allItems];
        BugItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        //We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BugItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BugItemStore sharedStore] allItems];
    BugItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    //Give detail view controller a pointer to the item object  in row
    [detailViewController setItem:selectedItem];
    
    //Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController animated:YES];
}


@end
