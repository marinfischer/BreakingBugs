// pg 307
//  DetailViewController.m
//  BreakingBugs
//
//  Created by Marin Fischer on 12/14/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "DetailViewController.h"
#import "BugItem.h"
#import "BugImageStore.h"
#import "BugItemStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize dismissBlock;
@synthesize item;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initFornewItem:" userInfo:nil];
    return nil;
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *color = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        color = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        color = [UIColor groupTableViewBackgroundColor];
    }
    [[self view] setBackgroundColor:color];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [bugTitleField setText:[item itemName]];
    [bugNumberField setText:[item bugNumber]];
    [priorityField setText:[NSString stringWithFormat:@"%d", [item priorityRating]]];
    
    //Create a NSDateFormatter taht will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    
    NSString *imageKey = [item imageKey];
    if (imageKey) {
        //Get image for imageKey from image store
        UIImage *imageToDisplay = [[BugImageStore sharedStore] imageForKey:imageKey];
        
        //Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // If there is no image, clear the imageView
        [imageView setImage:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear first responder and dismisses keyboard so we can now update BugItem
    [[self view] endEditing:YES];
    
    //"Save" changes to item
    [item setItemName:[bugTitleField text]];
    [item setBugNumber:[bugNumberField text]];
    [item setPriorityRating:[[priorityField text] intValue]];
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    //If the user cancelled, then remover the BugItem from the store
    [[BugItemStore sharedStore] removeItem:item];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setItem:(BugItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (IBAction)takePicture:(id)sender
{
    if ([imagePickerPopover isPopoverVisible]) {
        //If the popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    //Place image picker on the screen
    //Check for iPad before device before instanciating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        
        //Display the popover controller; sender is the camer bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)deletePhoto:(id)sender
{
    NSString *currentKey = [item imageKey];
    //Is there currently an image?
    if (currentKey) {
        //Delete the old image
        [[BugImageStore sharedStore] deleteImageForKey:currentKey];
    }
    
        [imageView setImage:nil];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    
    //Did the item already have an image?
    if (oldKey) {
        //Delete the old image
        [[BugImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    //Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    //Create a CFUUIDobject - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //Create a string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    //Use that unique ID to set our item's imageKey. Use __bridge to tell ARC that I will handle release of this
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    //Store image in the BNRImageStore with this key
    [[BugImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    //Release these before they loose their pointer (so we dont have a memory leak)
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    //Put that image image onto the screen in our image view
    [imageView setImage:image];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //If on the iphone, the image picker is presented modally. DIssmiss it.
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //If on the ipad, the image picker is in the popover. Dismiss the popover.
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}


@end
