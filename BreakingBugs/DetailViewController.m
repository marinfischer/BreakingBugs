// pg 270
//  DetailViewController.m
//  BreakingBugs
//
//  Created by Marin Fischer on 12/14/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "DetailViewController.h"
#import "BugItem.h"
#import "BugImageStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
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

- (void)setItem:(BugItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //If our device has a camera, we want to take a picture, otherwise, we just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    //Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    
    //Did the item already have an image?
    if (oldKey) {
        //Delete th old image
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
    
    //Take image picker off the screen- you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
