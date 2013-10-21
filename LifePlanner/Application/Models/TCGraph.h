//
//  TCGraph.h
//  GraphAPI
//
//  Created by Theodore Calmes on 5/27/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGraph : NSObject

@property (assign, nonatomic, readonly) int vertexCount;
@property (strong, nonatomic, readonly) NSArray *objects;

- (id)initWithObjects:(NSArray *)objects;
- (id)initWithVertices:(int)V;

- (void)addEdge:(int)v w:(int)w;

- (BOOL)vertex:(int)v isAdjacentToVertex:(int)w;

- (NSSet *)adjacentObjectsToVertex:(int)v;
- (NSSet *)nonAdjacentObjectsToVertex:(int)v;

- (NSEnumerator *)enumeratorForVertex:(int)v;
- (id)objectForVertex:(NSNumber *)v;
- (int)vertexForObject:(id)object;

@end

