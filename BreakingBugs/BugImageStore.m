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
    if (!sharedStore) {
        //Create the singleton
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
}

- (UIImage *)imageForKey:(NSString *)s
{
    return [dictionary objectForKey:s];
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s)
        return;
        [dictionary removeObjectForKey:s];
}

@end
