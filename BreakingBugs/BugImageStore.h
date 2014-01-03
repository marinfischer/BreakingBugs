//
//  BugImageStore.h
//  BreakingBugs
//
//  Created by Marin Fischer on 1/2/14.
//  Copyright (c) 2014 Marin Fischer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BugImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+ (BugImageStore *)sharedStore;

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;

@end
