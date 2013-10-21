//
//  ATCoreDataStore.h
//  AllTrails
//
//  Created by Mark Adams on 5/9/13.
//  Copyright (c) 2013 AllTrails. All rights reserved.
//

/** ATCoreDataStore provides quick access to the various components of the Core Data stack. The persistent store coordinator sits at the base of the stack and coordinates reading and writing to it's store; in our case, a SQLite database. Directly atop the persistent store coordinator sits the coordinator managed object context. This managed object context manages its own private queue. This pattern ensures that all disk IO occurs on a background thread. A main queue context descends from the coordinator context and serves to drive the UI. */

@interface TCCoreDataStore : NSObject

/** @name Getting the main queue context */

/** Returns the main queue's designated managed object context. */
+ (NSManagedObjectContext *)mainQueueContext;

/** @name Getting the private queue coordinator context */

/** Returns the root, private queue managed object context */
+ (NSManagedObjectContext *)coordinatorContext;

@end
