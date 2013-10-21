//
//  TCAppDelegate.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/5/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCAppDelegate.h"

#import "TCNode.h"
#import "TCTask.h"
#import "TCTaskValidation.h"
#import "TCHabit.h"
#import "TCHabitTask.h"

#import "TCGraph.h"

#import "TCGraphView.h"

@implementation TCAppDelegate
{
    TCGraphView *gv;
    NSTimer *timer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    TCNode *projectNode = [TCNode createNewUsingMainContextQueue:YES];
    projectNode.name = @"Get Fit";

    TCTaskValidation *lose5lb = [TCTaskValidation createNewUsingMainContextQueue:YES];
    lose5lb.name = @"lose 5 lb";
    lose5lb.parent = projectNode;

    TCTaskValidation *lose10lb = [TCTaskValidation createNewUsingMainContextQueue:YES];
    lose10lb.name = @"lose 10 lb";
    lose10lb.parent = projectNode;

    TCNode *runningNode = [TCNode createNewUsingMainContextQueue:YES];
    runningNode.name = @"Running";
    runningNode.parent = projectNode;

    TCTask *getShoesTask = [TCTask createNewUsingMainContextQueue:YES];
    getShoesTask.name = @"Buy running shoes";
    getShoesTask.parent = runningNode;

    TCTask *checkAmazonForShoes = [TCTask createNewUsingMainContextQueue:YES];
    checkAmazonForShoes.name = @"Check Amazon";
    checkAmazonForShoes.parent = getShoesTask;

    TCTask *subAMazon = [TCTask createNewUsingMainContextQueue:YES];
    subAMazon.name = @"Sub Amazon";
    subAMazon.parent = checkAmazonForShoes;

    TCTask *checkFootLockerForShoes = [TCTask createNewUsingMainContextQueue:YES];
    checkFootLockerForShoes.name = @"Check foot locker";
    checkFootLockerForShoes.parent = getShoesTask;

    TCHabitTask *finishShoesTask = [TCHabitTask createNewUsingMainContextQueue:YES];
    finishShoesTask.name = @"Check one store a day";
    finishShoesTask.task = getShoesTask;
    finishShoesTask.parent = getShoesTask;

    TCHabit *runAroundTheBlock = [TCHabit createNewUsingMainContextQueue:YES];
    runAroundTheBlock.name = @"Run around the block every day";
    runAroundTheBlock.parent = runningNode;

    TCTaskValidation *run1mile = [TCTaskValidation createNewUsingMainContextQueue:YES];
    run1mile.name = @"Be able to run 1 mile";
    run1mile.parent = runningNode;
    
    TCTaskValidation *run5mile = [TCTaskValidation createNewUsingMainContextQueue:YES];
    run5mile.name = @"Be able to run 5 mile";
    run5mile.parent = runningNode;

    TCNode *gymNode = [TCNode createNewUsingMainContextQueue:YES];
    gymNode.name = @"Gym";
    gymNode.parent = projectNode;

    TCHabit *lowerBodyOnWed = [TCHabit createNewUsingMainContextQueue:YES];
    lowerBodyOnWed.name = @"Workout legs on wed";
    lowerBodyOnWed.parent = gymNode;

    TCHabit *upperBodyOnWed = [TCHabit createNewUsingMainContextQueue:YES];
    upperBodyOnWed.name = @"Workout arms on thursday";
    upperBodyOnWed.parent = gymNode;

    TCTask *buyWeights = [TCTask createNewUsingMainContextQueue:YES];
    buyWeights.name = @"Buy weights";
    buyWeights.parent = gymNode;

    TCTask *research = [TCTask createNewUsingMainContextQueue:YES];
    research.name = @"Research";
    research.parent = gymNode;

    TCTask *readAboutRoutine = [TCTask createNewUsingMainContextQueue:YES];
    readAboutRoutine.name = @"Read about routine";
    readAboutRoutine.parent = research;

    TCTask *readAboutProtien = [TCTask createNewUsingMainContextQueue:YES];
    readAboutProtien.name = @"readAboutProtien";
    readAboutProtien.parent = research;

    TCTaskValidation *bench10 = [TCTaskValidation createNewUsingMainContextQueue:YES];
    bench10.name = @"Bench 100 lb";
    bench10.parent = gymNode;

    TCTaskValidation *pushups = [TCTaskValidation createNewUsingMainContextQueue:YES];
    pushups.name = @"Do 50 pushups";
    pushups.parent = gymNode;

    TCTaskValidation *situps = [TCTaskValidation createNewUsingMainContextQueue:YES];
    situps.name = @"Do 50 situps";
    situps.parent = gymNode;

    [[TCCoreDataStore mainQueueContext] save:nil];

    UIButton *go = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [go setTitle:@"Go" forState:UIControlStateNormal];
    [go setFrame:CGRectMake(0, 0, 50, 50)];
    go.center = CGPointMake(320/2, 450);
    [self.window addSubview:go];

    [go addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    
    return YES;
}

- (void)start:(id)obj
{
    [timer invalidate];
    [gv removeFromSuperview];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([TCNode class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"parent = nil"]];

    NSArray *results = [[TCCoreDataStore mainQueueContext] executeFetchRequest:fetchRequest error:nil];

    TCNode *top = [results lastObject];


    CGRect frame = CGRectMake(0, 0, 320, 400);
    gv = [[TCGraphView alloc] initWithFrame:frame node:top];
    gv.center = CGPointMake(320/2.0, 200+20);

    [self.window addSubview:gv];
    
    [self performSelector:@selector(begin) withObject:nil afterDelay:0.8];
}

- (void)begin
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:gv selector:@selector(calculate) userInfo:nil repeats:YES];
}

- (void)traverseNode:(TCNode *)node withBlock:(void(^)(TCNode *))block
{
    block(node);
    for (TCNode *child in node.children) {
        [self traverseNode:child withBlock:block];
    }
}

- (NSSet *)allLeavesForNode:(TCNode *)node
{
    NSMutableSet *leaves = [NSMutableSet new];
    [node traverse:^(TCNode *current) {
        if (current.children.count == 0) {
            [leaves addObject:current];
            NSLog(@"Name = %@, Depth = %d", current.name, [current depth]);
        }
    }];

    return leaves.copy;
}

@end
