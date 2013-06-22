//
//  TCCoreDataStore.m
//  AllTrails
//
//  Created by Mark Adams on 5/9/13.
//  Copyright (c) 2013 AllTrails. All rights reserved.
//

#import "TCCoreDataStore.h"

@interface TCCoreDataStore ()

@property (strong, nonatomic) NSManagedObjectContext *mainQueueContext;
@property (strong, nonatomic) NSManagedObjectContext *coordinatorContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end

@implementation TCCoreDataStore

#pragma mark - Singleton Access

+ (NSManagedObjectContext *)mainQueueContext
{
    return [[self defaultStore] mainQueueContext];
}

+ (NSManagedObjectContext *)coordinatorContext
{
    return [[self defaultStore] coordinatorContext];
}

#pragma mark - Lifecycle

+ (TCCoreDataStore *)defaultStore
{
    static TCCoreDataStore *store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [self new];
    });

    return store;
}

- (id)init
{
    self = [super init];

    if (!self) {
        return nil;
    }

    [self startObservingSaveNotifications];

    return self;
}

- (void)dealloc
{
    [self stopObservingSaveNotifications];
}

#pragma mark - Getters

- (NSManagedObjectContext *)mainQueueContext
{
    if (!_mainQueueContext) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainQueueContext setParentContext:[self coordinatorContext]];
    }

    return _mainQueueContext;
}

- (NSManagedObjectContext *)coordinatorContext
{
    if (!_coordinatorContext) {
        _coordinatorContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_coordinatorContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }

    return _coordinatorContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;

        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:&error]) {
#if !CONFIGURATION_Release
            if ([error code] == NSMigrationMissingSourceModelError) {
                [self resetPersistentStore];
            }
#endif
        }
    }

    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }

    return _managedObjectModel;
}

- (void)startObservingSaveNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)stopObservingSaveNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
    NSManagedObjectContext *context = [notification object];

    if ([context parentContext] == [self coordinatorContext]) {
        [[self coordinatorContext] performBlock:^{
            [[self coordinatorContext] save:nil];
        }];
    }
}

- (void)resetPersistentStore
{
    [self stopObservingSaveNotifications];
    [self.mainQueueContext reset];
    self.mainQueueContext = nil;
    [self.coordinatorContext reset];
    self.coordinatorContext = nil;

    if ([self.persistentStoreCoordinator removePersistentStore:[[self.persistentStoreCoordinator persistentStores] lastObject] error:nil]) {
        [[NSFileManager defaultManager] removeItemAtURL:[self persistentStoreURL] error:nil];
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:nil];
    }
}

- (NSURL *)persistentStoreURL
{
    NSString *appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    appName = [appName stringByAppendingString:@".sqlite"];

    return [[NSFileManager appLibraryDirectory] URLByAppendingPathComponent:appName];
}

- (NSDictionary *)persistentStoreOptions
{
    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @NO};
}

@end
