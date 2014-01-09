//
//  BugItem.m
//  BreakingBugs
//
//  Created by Marin Fischer on 12/10/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "BugItem.h"

@implementation BugItem

@synthesize imageKey;
@synthesize container;
@synthesize containedItem;
@synthesize itemName, bugNumber, dateCreated, priorityRating, bugCreator, bugAssignee, modifiedDate;

@synthesize thumbnail, thumbnailData;

- (UIImage *)thumbnail
{
    //If there is no thumbnailData, then i have no thumbnail to return
    if (!thumbnailData) {
        return nil;
    }
    //if i have not yet created my thumbnail image from my data, do so now
    if (!thumbnail) {
        //Create the image from teh data
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    //The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    //Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    //Create a tranparent bitmap conext with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    //Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    //Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    //Center the image in teh thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio *origImageSize.width;
    projectRect.size.height = ratio *origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    //draw the image on it
    [image drawInRect:projectRect];
    
    //Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    //Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    //Cleanup image context rescources, we're done
    UIGraphicsEndImageContext();
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:bugNumber forKey:@"bugNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeObject:bugAssignee forKey:@"bugAssignee"];
    [aCoder encodeObject:bugCreator forKey:@"bugCreator"];
    [aCoder encodeObject:modifiedDate forKey:@"modifiedDate"];
    
    [aCoder encodeInt:priorityRating forKey:@"priorityRating"];
    
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setBugNumber:[aDecoder decodeObjectForKey:@"bugNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setBugAssignee:[aDecoder decodeObjectForKey:@"bugAssignee"]];
        [self setBugCreator:[aDecoder decodeObjectForKey:@"bugCreator"]];
        
        [self setPriorityRating:[aDecoder decodeIntForKey:@"priorityRating"]];
        
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        modifiedDate = [aDecoder decodeObjectForKey:@"modifiedDate"];
        
        thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    return self;
}

+ (id)randomItem
{
   // int randomValue = rand() % 10;
    NSString *randomBugNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    BugItem *newItem =
    [[self alloc] initWithBugNumber:randomBugNumber];
    return newItem;
}

- (id)initWithBugNumber:(NSString *)bNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if(self) {
        // Give the instance variables initial values
        [self setBugNumber:bNumber];
        dateCreated = [[NSDate alloc] init];
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init
{
    return [self initWithBugNumber:@""];
}


- (void)setContainedItem:(BugItem *)i
{
    containedItem = i;
    [i setContainer:self];
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Priority #%d, recorded on %@, modified on %@, create by %@ and assigned to %@",
     itemName,
     bugNumber,
     priorityRating,
     dateCreated,
     modifiedDate,
     bugCreator,
     bugAssignee];
    return descriptionString;
}
- (void)dealloc
{
    NSLog(@"Destroyed: %@ ", self);
}


@end
