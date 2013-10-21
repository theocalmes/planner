//
//  NSManagedObject+ObjectCreation.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "NSManagedObject+ObjectCreation.h"

@implementation NSManagedObject (ObjectCreation)

+ (id)insertNewManagedObjectOfClass:(Class)class usingMainQueue:(BOOL)useMainQueue
{
    NSManagedObjectContext *context = (useMainQueue) ? [TCCoreDataStore mainQueueContext] : [TCCoreDataStore coordinatorContext];
    id obj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(class) inManagedObjectContext:context];

    return obj;
}

+ (id)createNewUsingMainContextQueue:(BOOL)useMainContext
{
    NSManagedObjectContext *context = (useMainContext) ? [TCCoreDataStore mainQueueContext] : [TCCoreDataStore coordinatorContext];

    id obj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];

    return obj;
}

@end
