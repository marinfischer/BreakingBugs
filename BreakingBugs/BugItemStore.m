//
//  BugItemStore.m
//  BreakingBugs
//
//  Created by Marin Fischer on 12/10/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//
//BugItemStore is a singleton
//

#import "BugItemStore.h"
#import "BugItem.h"
#import "BugImageStore.h"

@implementation BugItemStore

//When this message is sent to the BugItemStore class, the class will check to see if the single instance of BugItemStore has already been created. If it has, the class will return the instance. If not, it will create the instance and return it.
+ (BugItemStore *)sharedStore
{
    //make it static so our once instance cannot get destroyed
    static BugItemStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

//To ensure another BugItemStore cannot get allocated we have alloc with zone return the sharesStore that we created
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
                    
        //If the array hadn't been save previously, create a new empty one
        if (!allItems)
                    allItems = [[NSMutableArray alloc] init];
                    
    }
    return self;
}

- (NSArray *)allItems
{
    return allItems;
}

- (BugItem *)createItem
{
    BugItem *p = [BugItem randomItem];
   // BugItem *p = [[BugItem alloc] init];
    [allItems addObject:p];
    return p;
}

- (void)removeItem:(BugItem *)p
{
    NSString *key = [p imageKey];
    [[BugImageStore sharedStore] deleteImageForKey:key];
    [allItems removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to)
    {
        return;
    }
    //get pointer to object being moved so we can re-insert it
    BugItem *p = [allItems objectAtIndex:from];
    
    //Remove p from array
    [allItems removeObjectAtIndex:from];
    
    //Insert p in array at new location
    [allItems insertObject:p atIndex:to];
}

//save data in the file system under documents
- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get one and only document from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

//saves every bugItem in allItems to the itemArchivePath
- (BOOL)saveChanges
{
    //returns success or failure
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}

@end
