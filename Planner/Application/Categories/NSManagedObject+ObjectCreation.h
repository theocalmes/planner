//
//  NSManagedObject+ObjectCreation.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ObjectCreation)

+ (id)insertNewManagedObjectOfClass:(Class)class usingMainQueue:(BOOL)useMainQueue;
+ (id)createNewUsingMainContextQueue:(BOOL)useMainContext;

@end
