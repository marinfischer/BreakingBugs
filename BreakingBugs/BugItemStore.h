//
//  BugItemStore.h
//  BreakingBugs
//
//  Created by Marin Fischer on 12/10/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//
//This is a singleton. There will only be one instance of this type in
//the application; if you try to create another instance, the class
//will quietly return the existing instance instead. A singleton is
//useful when you have an object that many objects will talk to. Those
//objects can ask the singleton class for its one instance, which is
//better than passing that instance as an argument to every method that
//will use it.
//

#import <Foundation/Foundation.h>

@class BugItem;

@interface BugItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BugItemStore *)sharedStore;

- (void)removeItem:(BugItem *)p;
- (NSArray *)allItems;
- (BugItem *)createItem;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;

@end
