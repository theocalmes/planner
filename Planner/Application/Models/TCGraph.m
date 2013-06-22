//
//  TCGraph.m
//  GraphAPI
//
//  Created by Theodore Calmes on 5/27/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCGraph.h"

@interface TCGraph ()
@property (strong, nonatomic) NSArray *adjacencySets;
@property (strong, nonatomic, readwrite) NSArray *objects;
@property (assign, nonatomic, readwrite) int vertexCount;
@end

@implementation TCGraph

- (id)initWithVertices:(int)V
{
    self = [super init];
    if (self) {
        _vertexCount = V;
        NSMutableArray *temp = [NSMutableArray new];
        for (NSInteger i = 0; i < _vertexCount; i++) {
            [temp addObject:[NSMutableSet new]];
        }
        _adjacencySets = temp.copy;
    }

    return self;
}

- (id)initWithObjects:(NSArray *)objects
{
    self = [super init];
    if (self) {
        _vertexCount = objects.count;
        NSMutableArray *temp = [NSMutableArray new];
        for (NSInteger i = 0; i < _vertexCount; i++) {
            [temp addObject:[NSMutableSet new]];
        }
        _adjacencySets = temp.copy;

        _objects = objects;
    }

    return self;
}

- (void)addEdge:(int)v w:(int)w
{
    BOOL isContained = [self.adjacencySets[v] containsObject:@(w)];
    BOOL otherContains = [self.adjacencySets[w] containsObject:@(v)];
    BOOL containsSelf = [self.adjacencySets[v] containsObject:@(v)];
    BOOL containsOther = [self.adjacencySets[w] containsObject:@(w)];
    
    if (isContained || otherContains || containsSelf || containsOther) return;

    [self.adjacencySets[v] addObject:@(w)];
    [self.adjacencySets[w] addObject:@(v)];
}

- (BOOL)vertex:(int)v isAdjacentToVertex:(int)w
{
    return [self.adjacencySets[v] containsObject:@(w)];
}

- (NSSet *)adjacentObjectsToVertex:(int)v
{
    NSMutableSet *adj = [NSMutableSet new];
    for (NSNumber *n in self.adjacencySets[v]) {
        [adj addObject:[self objectForVertex:n]];
    }

    return adj.copy;
}

- (NSSet *)nonAdjacentObjectsToVertex:(int)v
{
    NSMutableSet *objects = [[NSMutableSet alloc] initWithArray:self.objects];
    [objects removeObject:[self.objects objectAtIndex:v]];

    [objects minusSet:[self adjacentObjectsToVertex:v]];

    return objects.copy;
}

- (NSEnumerator *)enumeratorForVertex:(int)v
{
    return [self.adjacencySets[v] objectEnumerator];
}

- (id)objectForVertex:(NSNumber *)v
{
    return self.objects[[v integerValue]];
}

- (int)vertexForObject:(id)object
{
    return [self.objects indexOfObject:object];
}

@end
