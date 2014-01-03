//
//  DetailViewController.h
//  BreakingBugs
//
//  Created by Marin Fischer on 12/14/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BugItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UITextField *bugTitleField;
    
    __weak IBOutlet UITextField *priorityField;
    __weak IBOutlet UITextField *bugNumberField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) BugItem *item;
- (IBAction)takePicture:(id)sender;

@end
