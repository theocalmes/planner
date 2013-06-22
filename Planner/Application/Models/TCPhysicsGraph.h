//
//  TCPhysicsGraph.h
//  Planner
//
//  Created by Theodore Calmes on 6/21/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCGraph.h"

typedef struct TCPhysicsBody {
    CGPoint f;
    CGPoint v;
    CGPoint d;
    CGPoint p;
} TCPhysicsBody;

@interface TCPhysicsGraph : TCGraph
@property (assign, nonatomic) CGRect frame;
@property (assign, nonatomic) NSInteger touchIndex;
@property (assign, nonatomic) CGPoint touchPoint;
- (TCPhysicsBody)bodyForVertex:(int)vertex;
- (void)simulate;

@end
