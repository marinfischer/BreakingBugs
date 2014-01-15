//
//  BugItemCell.m
//  BreakingBugs
//
//  Created by Marin Fischer on 1/9/14.
//  Copyright (c) 2014 Marin Fischer. All rights reserved.
//

#import "BugItemCell.h"

@implementation BugItemCell
@synthesize nameLabel;
@synthesize bugNumberLabel;
@synthesize priorityLabel;
@synthesize thumbnailView;
@synthesize controller;
@synthesize tableView;

- (IBAction)showImage:(id)sender
{
    //Get this name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    //selector is now "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath"];
    
    //Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
    
    //ignore warning for now
    [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}
@end
