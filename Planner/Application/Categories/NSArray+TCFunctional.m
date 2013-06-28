//
//  NSArray+TCFunctional.m
//  Planner
//
//  Created by Theodore Calmes on 6/28/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "NSArray+TCFunctional.h"

@implementation NSArray (TCFunctional)

- (NSArray *)map:(id (^)(id))block
{
    NSMutableArray *mapped = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [mapped addObject:block(obj)];
    }

    return mapped.copy;
}

- (NSArray *)select:(BOOL (^)(id))block
{
    NSMutableArray *selected = [NSMutableArray array];
    for (id obj in self) {
        if (block(obj)) {
            [selected addObject:obj];
        }
    }

    return selected.copy;
}

- (NSArray *)split:(BOOL (^)(id))block
{
    NSMutableArray *split = [NSMutableArray array];

    NSMutableArray *gather = [NSMutableArray array];
    for (id obj in self) {
        if (block(obj)) {
            [split addObject:gather.copy];
            [gather removeAllObjects];
            [gather addObject:obj];
        }
        else {
            [gather addObject:obj];
        }
    }

    return split.copy;
}

@end
