//
//  BugImageStore.m
//  BreakingBugs
//
//  Created by Marin Fischer on 1/2/14.
//  Copyright (c) 2014 Marin Fischer. All rights reserved.
//
// BugImageStore is a singleton

#import "BugImageStore.h"

@implementation BugImageStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BugImageStore *)sharedStore
{
    static BugImageStore *sharedStore = nil;
    if (!sharedStore)
    {
        //Create the singleton
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    //Create full path for image
    NSString *imagePath = [self imagePathForKey:s];
    
    //Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(i, 0.5);
    
    //Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
    //if possible, get it from the dictionary
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result)
    {
        //create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        //if we found an image on the file system, place it into the cache
        if (result)
        {
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:s]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s)
        return;
        [dictionary removeObjectForKey:s];
    
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory  = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
