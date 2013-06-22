//
//  TCNode.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCNode.h"
#import "TCGraph.h"
#import "TCPhysicsGraph.h"

@implementation TCNode

@dynamic creationDate;
@dynamic detailedDescription;
@dynamic isActive;
@dynamic name;
@dynamic children;
@dynamic parent;

- (NSString *)description
{
    return self.name;
}

#pragma mark - Node Traversal

- (void)traverse:(TCApply)applyBlock
{
    applyBlock(self);
    for (TCNode *child in self.children) {
        [child traverse:applyBlock];
    }
}

- (NSUInteger)depth
{
    TCNode *temp = self;

    NSUInteger depth = 0;

    while (temp.parent) {
        depth++;
        temp = temp.parent;
    }

    return depth;
}

#pragma mark - Node Gathering

- (NSSet *)leaves
{
    NSMutableSet *leaves = [NSMutableSet new];
    [self traverse:^(TCNode *current) {
        if (current.children.count == 0) {
            [leaves addObject:current];
        }
    }];

    [leaves removeObject:self];

    return leaves.copy;
}

- (NSSet *)branches
{
    NSMutableSet *branches = [NSMutableSet new];
    for (TCNode *child in self.children) {
        if (child.children) {
            [branches addObject:child];
        }
    }

    return branches.copy;
}

#pragma mark - Graph Extraction

- (TCPhysicsGraph *)graph
{
    NSMutableArray *allNodes = [NSMutableArray new];
    [self traverse:^(TCNode *current) {
        [allNodes addObject:current];
    }];

    TCPhysicsGraph *graph = [[TCPhysicsGraph alloc] initWithObjects:allNodes.copy];

    [self traverse:^(TCNode *current) {
        if (current.parent && current != self) {
            int v = [allNodes indexOfObject:current];
            int w = [allNodes indexOfObject:current.parent];

            [graph addEdge:v w:w];
        }
    }];
    
    return graph;
}


#pragma mark - Subclassing

+ (id)createNewUsingMainContextQueue:(BOOL)useMainContext
{
    id obj = [super createNewUsingMainContextQueue:useMainContext];
    [obj setCreationDate:[NSDate new]];

    return obj;
}

@end
