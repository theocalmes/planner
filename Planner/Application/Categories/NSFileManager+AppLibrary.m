//
//  NSFileManager+AppLibrary.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "NSFileManager+AppLibrary.h"

@implementation NSFileManager (AppLibrary)

+ (NSURL *)appLibraryDirectory
{
    return [[[self defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
