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
    if (self) {
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
    [allItems addObject:p];
    return p;
}

- (void)removeItem:(BugItem *)p
{
    [allItems removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    //get pointer to object being moved so we can re-insert it
    BugItem *p = [allItems objectAtIndex:from];
    
    //Remove p from array
    [allItems removeObjectAtIndex:from];
    
    //Insert p in array at new location
    [allItems insertObject:p atIndex:to];
}

@end
