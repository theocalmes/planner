//
//  TCGraphView.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCGraphView.h"
#import "TCGraph.h"
#import "TCPhysicsGraph.h"

#import "UIView+Frame.h"
/*
double randomRange(double low, double high)
{
    return ((double)arc4random() / 0x100000000) * (high - low) + low;
}

float distance(CGPoint a, CGPoint b)
{
    return powf(a.x - b.x, 2) + powf(a.y - b.y, 2);
}
 */

@interface TCGraphView ()
@property (strong, nonatomic) TCNode *top;
//@property (strong, nonatomic) TCGraph *graph;
@property (strong, nonatomic) TCPhysicsGraph *graph;
@property (assign, nonatomic) CGPoint *vertexPoints;
@property (assign, nonatomic) CGPoint *vertexVelocity;
@property (assign, nonatomic) int touchIndex;
@property (assign, nonatomic) CGPoint touchPoint;
@property (assign, nonatomic) float totalMotionDelta;
@end

@implementation TCGraphView

- (id)initWithFrame:(CGRect)frame node:(TCNode *)node
{
    self = [super initWithFrame:frame];
    if (self) {
        _top = node;
        _graph = [node graph];
        [_graph setFrame:frame];
        _touchIndex = -1;

        _vertexPoints = malloc(_graph.vertexCount * sizeof(CGPoint));
        for (NSInteger i = 0; i < _graph.vertexCount; i++) {
            _vertexPoints[i] = CGPointMake((arc4random() % 60 + (int)((frame.size.width - 60) / 2.0)), (arc4random() % 60 + (int)((frame.size.height - 60) / 2.0)));

            if ([[self.graph objectForVertex:@(i)] depth] == 0) _vertexPoints[i] = BKRectCenter(self.frame);
        }

        _vertexVelocity = malloc(_graph.vertexCount * sizeof(CGPoint));
        for (NSInteger i = 0; i < _graph.vertexCount; i++) {
            _vertexVelocity[i] = CGPointZero;//CGPointMake((float)randomRange(-3.0, 3.0), (float)randomRange(-3.0, 3.0));
        }
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIColor *)colorForNode:(TCNode *)node
{
    UIColor *color = nil;

    if ([node isKindOfClass:[TCHabit class]]) {
        color = [UIColor redColor];
    }
    else if ([node isKindOfClass:[TCTaskValidation class]]) {
        color = [UIColor greenColor];
    }
    else if ([node isKindOfClass:[TCTask class]]) {
        color = [UIColor blueColor];
    }
    else {
        color = [UIColor whiteColor];
    }

    return color;
}

- (TCGraph *)randomGraph
{
    int vertexCount = arc4random() % 20 + 5;
    TCGraph *graph = [[TCGraph alloc] initWithVertices:vertexCount];

    for (NSInteger i = 0; i < vertexCount; i++) {
        while ([[graph enumeratorForVertex:i] allObjects].count == 0) {
            int w = arc4random() % vertexCount;
            while (i == w) {
                w = arc4random() % vertexCount;
            }
            [graph addEdge:i w:w];
        }
    }

    int edges = arc4random() % 20 + 5;
    for (NSInteger i = 0; i < edges; i++) {
        int v = arc4random() % vertexCount;
        int w = arc4random() % vertexCount;

        [graph addEdge:v w:w];
    }

    return graph;
}

- (int)indexOfVertexForTouchLocation:(CGPoint)a
{
    float minDistance = FLT_MAX;
    int index = 0;

    for (NSInteger i = 0; i < self.graph.vertexCount; i++) {

        CGPoint b = [self.graph bodyForVertex:i].p;
        float d = powf(a.x - b.x, 2) + powf(a.y - b.y, 2);

        if (d < minDistance) {
            minDistance = d;
            index = i;
        }
    }

    return index;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.touchPoint = touchPoint;

    self.touchIndex = [self indexOfVertexForTouchLocation:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.touchPoint = touchPoint;
    
    self.vertexPoints[self.touchIndex].x = touchPoint.x;
    self.vertexPoints[self.touchIndex].y = touchPoint.y;
    self.vertexVelocity[self.touchIndex].x = 0;
    self.vertexVelocity[self.touchIndex].y = 0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchIndex = -1;
}
/*
- (void)calculate
{
    int V = self.graph.vertexCount;

    float k = 22.0;
    float a = 0.1;
    float b = 0.85;
    float c = 0.05;

    float K = 1 * sqrtf((CGRectGetHeight(self.frame) * CGRectGetWidth(self.frame)) / V);

    for (NSInteger i = 0; i < 1; i++) {

        CGPoint *tempP = malloc(_graph.vertexCount * sizeof(CGPoint));
        CGPoint *tempV = malloc(_graph.vertexCount * sizeof(CGPoint));
        
        for (NSInteger v = 0; v < V; v++) {

            CGPoint vertexPoint = self.vertexPoints[v];
            CGPoint velocity = self.vertexVelocity[v];
            
            float fx = 0;
            float fy = 0;
            
            for (NSInteger w = 0; w < V; w++) {
                if (w == v) continue;

                CGPoint adjPoint = self.vertexPoints[w];
                float d = distance(vertexPoint, adjPoint);

                float scale = 1.0 - [[self.graph objectForVertex:@(v)] depth] / 8.0;

                //fx += scale * k * (vertexPoint.x - adjPoint.x) / d;
                //fy += scale * k * (vertexPoint.y - adjPoint.y) / d;

                float dx = (vertexPoint.x - adjPoint.x);
                fx += (dx/fabsf(dx)) * (powf(K, 2) / fabsf(dx));

                float dy = (vertexPoint.y - adjPoint.y);
                fy += (dy/fabsf(dy)) * (powf(K, 2) / fabsf(dy));

                if ([self.graph vertex:v isAdjacentToVertex:w]) {
                    fx += a * (adjPoint.x - vertexPoint.x);
                    fy += a * (adjPoint.y - vertexPoint.y);
                }
            }

            velocity.x = 0.8 * velocity.x + b * fx;
            velocity.y = 0.8 * velocity.y + b * fy;

            tempV[v] = velocity;
            tempP[v] = BKAddPoints(vertexPoint, velocity);

            
            if (v == self.touchIndex) {
                tempV[v] = CGPointMake(0,0);
                tempP[v] = self.touchPoint;
            }

            if ([[self.graph objectForVertex:@(v)] depth] == 0) {
                tempP[v] =  BKRectCenter(self.frame);//CGPointMake(160, 30);
                tempV[v] = velocity;
            }//continue;

            if (tempP[v].x >= CGRectGetMaxX(self.frame) - 5) {
                tempV[v].x *= -c;
                tempP[v].x = CGRectGetMaxX(self.frame) - 5;
            }
            else if (tempP[v].x <= CGRectGetMinX(self.frame) + 5) {
                tempV[v].x *= -c;
                tempP[v].x = CGRectGetMinX(self.frame) + 5;
            }
            if (tempP[v].y >= CGRectGetMaxY(self.frame) - 5) {
                tempV[v].y *= -c;
                tempP[v].y = CGRectGetMaxY(self.frame) - 5;
            }
            else if (tempP[v].y <= CGRectGetMinY(self.frame) + 5) {
                tempV[v].y *= -c;
                tempP[v].y = CGRectGetMinY(self.frame) + 5;
            }
        }

        for (NSInteger v = 0; v < V; v++) {
            self.vertexPoints[v] = tempP[v];
            self.vertexVelocity[v] = tempV[v];
        }

        free(tempP);
        free(tempV);
    }

    [self setNeedsDisplay];
}
 */

- (void)calculate
{
    [self.graph simulate];
    [self setNeedsDisplay];
}

- (void)drawNode:(TCNode *)node rect:(CGRect)rect context:(CGContextRef)context
{
    if ([node isKindOfClass:[TCHabit class]]) {
        [[UIColor blueColor] setFill];

        CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint left = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGPoint right = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));

        CGContextMoveToPoint(context, left.x, left.y);
        CGContextAddLineToPoint(context, mid.x, mid.y);
        CGContextAddLineToPoint(context, right.x, right.y);
        CGContextAddLineToPoint(context, left.x, left.y);

        CGContextFillPath(context);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef contex = UIGraphicsGetCurrentContext();

    [[UIColor blackColor] setStroke];
    CGRect nodeBase = CGRectMake(0, 0, 20, 20);

    for (NSInteger v = 0; v < self.graph.vertexCount; v++) {

        CGPoint center = [self.graph bodyForVertex:v].p;// self.vertexPoints[v];
        NSArray *adj = [[self.graph enumeratorForVertex:v] allObjects];

        for (NSNumber *w in adj) {
            CGPoint adjPoint = [self.graph bodyForVertex:[w integerValue]].p;//self.vertexPoints[[w integerValue]];
            
            if (!adjPoint.x || !adjPoint.y) continue;
            
            CGContextMoveToPoint(contex, center.x, center.y);
            CGContextAddLineToPoint(contex, adjPoint.x, adjPoint.y);
        }
        CGContextStrokePath(contex);
    }

    for (NSInteger v = 0; v < self.graph.vertexCount; v++) {

        CGPoint center = [self.graph bodyForVertex:v].p;//self.vertexPoints[v];
        float scale = 1.0 - [[self.graph objectForVertex:@(v)] depth] / 8.0;
        scale *= scale;
        CGRect rect = BKScaleRect(nodeBase, CGPointMake(scale, scale));
        //rect = BKCenterRect(rect, center);

        //[self drawNode:[self.graph objectForVertex:@(v)] rect:rect context:contex];

        [[self colorForNode:[self.graph objectForVertex:@(v)]] setFill];

        CGContextFillEllipseInRect(contex, BKCenterRect(rect, center));
        CGContextStrokeEllipseInRect(contex, BKCenterRect(rect, center));
    }
}

@end
