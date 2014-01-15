//
//  ImageViewController.h
//  BreakingBugs
//
//  Created by Marin Fischer on 1/14/14.
//  Copyright (c) 2014 Marin Fischer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *imageView;
    
}

@property (nonatomic, strong) UIImage *image;
@end
