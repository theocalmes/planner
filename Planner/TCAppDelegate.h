//
//  TCAppDelegate.h
//  Planner
//
//  Created by Theodore Calmes on 6/17/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
