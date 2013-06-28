//
//  NSArray+TCFunctional.h
//  Planner
//
//  Created by Theodore Calmes on 6/28/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TCFunctional)

- (NSArray *)map:(id(^)(id obj))block;
- (NSArray *)select:(BOOL(^)(id obj))block;
- (NSArray *)split:(BOOL(^)(id obj))block;

@end
