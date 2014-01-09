//
//  BugItemCell.h
//  BreakingBugs
//
//  Created by Marin Fischer on 1/9/14.
//  Copyright (c) 2014 Marin Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BugItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *bugNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@end
