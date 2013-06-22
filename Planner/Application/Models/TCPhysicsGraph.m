//
//  TCPhysicsGraph.m
//  Planner
//
//  Created by Theodore Calmes on 6/21/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCPhysicsGraph.h"
#import "UIView+Frame.h"

double randomRange(double low, double high)
{
    return ((double)arc4random() / 0x100000000) * (high - low) + low;
}

float distance(CGPoint a, CGPoint b)
{
    return powf(a.x - b.x, 2) + powf(a.y - b.y, 2);
}

TCPhysicsBody TCMakeRandomPhysicsBody(CGPoint center)
{
    TCPhysicsBody body;
    body.f = CGPointZero;
    body.v = CGPointZero;
    body.d = CGPointZero;
    body.p = BKAddPoints(center, CGPointMake((float)randomRange(-10, 10), (float)randomRange(-10, 10)));
    
    return body;
}

@interface TCPhysicsGraph ()
@property (assign, nonatomic) TCPhysicsBody *physicsBodies;
@end

@implementation TCPhysicsGraph

- (void)setFrame:(CGRect)frame
{
    _frame = frame;

    CGPoint center = BKRectCenter(frame);

    _physicsBodies = malloc(self.vertexCount * sizeof(TCPhysicsBody));
    for (NSInteger i = 0; i < self.vertexCount; i++) {
        _physicsBodies[i] = TCMakeRandomPhysicsBody(center);
    }
}

- (TCPhysicsBody)bodyForVertex:(int)vertex
{
    return self.physicsBodies[vertex];
}

- (void)applyForces
{
    NSInteger V = self.vertexCount;
    float k = 22;
    //float k = 22.0;
    float a = 0.2;

    for (NSInteger v = 0; v < V; v++) {

        TCPhysicsBody vBody = self.physicsBodies[v];
        vBody.f = CGPointZero;

        for (NSInteger w = 0; w < V; w++) {
            if (w == v) continue;

            TCPhysicsBody wBody = self.physicsBodies[w];

            float d = distance(vBody.p, wBody.p);
            CGPoint dR = BKSubPoints(vBody.p, wBody.p);
            float dx = dR.x;
            float dy = dR.y;
            
            vBody.f.x += k * (dx / d);
            vBody.f.y += k * (dy / d);

            if ([self vertex:v isAdjacentToVertex:w]) {
                vBody.f.x += -dx * a;
                vBody.f.y += -dy * a;
            }
        }
        vBody.f.y += .5;
        self.physicsBodies[v] = vBody;
    }
}

- (void)applyVelocity
{
    CGPoint scale = CGPointMake(0.8, 0.8);
    float c = 0.05;
    NSInteger V = self.vertexCount;
    for (NSInteger v = 0; v < V; v++) {

        TCPhysicsBody vBody = self.physicsBodies[v];

        vBody.v = BKAddPoints(BKScalePoint(vBody.v, scale), BKScalePoint(vBody.f, scale));
        vBody.p = BKAddPoints(vBody.p, vBody.v);

        if (vBody.p.x >= CGRectGetMaxX(self.frame) - 5) {
            vBody.v.x *= -c;
            vBody.p.x = CGRectGetMaxX(self.frame) - 5;
        }
        else if (vBody.p.x <= CGRectGetMinX(self.frame) + 5) {
            vBody.v.x *= -c;
            vBody.p.x = CGRectGetMinX(self.frame) + 5;
        }
        if (vBody.p.y >= CGRectGetMaxY(self.frame) - 5) {
            vBody.v.y *= -c;
            vBody.p.y = CGRectGetMaxY(self.frame) - 5;
        }
        else if (vBody.p.y <= CGRectGetMinY(self.frame) + 5) {
            vBody.v.y *= -c;
            vBody.p.y = CGRectGetMinY(self.frame) + 5;
        }

        if (v == self.touchIndex) {
            vBody.v = CGPointMake(0,0);
            vBody.p = self.touchPoint;
        }

        if ([[self objectForVertex:@(v)] depth] == 0) {
            vBody.p =  BKRectCenter(self.frame);//CGPointMake(160, 30);
        }

        self.physicsBodies[v] = vBody;
    }
}

- (void)simulate
{
    [self applyForces];
    [self applyVelocity];
}

@end
