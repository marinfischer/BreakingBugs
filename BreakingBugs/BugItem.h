//
//  BugItem.h
//  BreakingBugs
//
//  Created by Marin Fischer on 12/10/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BugItem : NSObject <NSCoding>
{
}
+ (id)randomItem;

- (id)initWithBugNumber:(NSString *)bNumber;

@property (nonatomic, strong) BugItem *containedItem;
@property (nonatomic, weak) BugItem *container;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *bugNumber;
@property (nonatomic) int priorityRating;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, copy) NSString *bugCreator;
@property (nonatomic, copy) NSString *bugAssignee;
@property (nonatomic, readonly, strong) NSDate *modifiedDate;

@property (nonatomic, copy) NSString *imageKey;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;

- (void)setThumbnailDataFromImage: (UIImage *)image;

@end
