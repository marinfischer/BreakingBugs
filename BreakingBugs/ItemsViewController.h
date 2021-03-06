//
//  ItemsViewController.h
//  BreakingBugs
//
//  Created by Marin Fischer on 12/10/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "BugItemCell.h"

@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}

- (IBAction)addNewItem:(id)sender;

@end
