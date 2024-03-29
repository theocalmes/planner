//
//  TCMindMap.m
//  Planner
//
//  Created by Theodore Calmes on 6/22/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCMindMap.h"
#import "UIView+frame.h"
#import "TCNode.h"
#import "TCDrawingData.h"
#import "UIColor+Serialization.h"

#import "TCMindMapNode.h"

float d(CGPoint a, CGPoint b)
{
    return sqrtf(powf(a.x - b.x, 2) + powf(a.y - b.y, 2));
}

@interface TCMindMap ()
@property (strong, nonatomic) TCNode *selectedNode;
@property (strong, nonatomic) UIBezierPath *selectedNodeAddButtonPath;
@property (strong, nonatomic) NSMapTable *nodeToHitBoxPathMap;
@property (strong, nonatomic) NSMapTable *nodeToDrawingPathMap;
@property (strong, nonatomic) NSMapTable *nodeToShapeNodeMap;
@property (assign, nonatomic) CGPoint newNodePathEndPoint;
@property (assign, nonatomic) CGPoint newNodePathStartPoint;
@property (strong, nonatomic) UIFont *defaultFont;
@property (strong, nonatomic) NSMutableArray *paths;
@property (strong, nonatomic) SKShapeNode *tempNode;

@property (strong, nonatomic) NSMapTable *nodeMap;
@end

@implementation TCMindMap
{
    CGPoint debug;
    float scale;
}

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _nodeToHitBoxPathMap = [NSMapTable strongToStrongObjectsMapTable];
        _nodeToDrawingPathMap = [NSMapTable strongToStrongObjectsMapTable];
        _nodeToShapeNodeMap = [NSMapTable strongToStrongObjectsMapTable];
        _nodeMap = [NSMapTable strongToStrongObjectsMapTable];
        _state = TCMindMapStateIdle;
        _defaultFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _paths = [NSMutableArray array];

        _tempNode = [SKShapeNode node];
        _tempNode.hidden = YES;
        _tempNode.strokeColor = [UIColor blackColor];
        [self addChild:_tempNode];
    }

    return self;
}

- (void)setTopNode:(TCNode *)topNode
{
    _topNode = topNode;
    [_topNode traverse:^(TCNode *current) {
        [self addNode:current];
    }];
}

- (void)addNode:(TCNode *)node
{
    TCMindMapNode *mapNode = [[TCMindMapNode alloc] initWithNode:node];
    [self.nodeMap setObject:mapNode forKey:node];

    [self addChild:mapNode];
}

- (TCNode *)nodeForPoint:(CGPoint)point
{
    CGPoint touchPoint = [self adjustedPointForPoint:point];
    __block TCNode *node = nil;
    [self.topNode traverse:^(TCNode *current) {
        TCMindMapNode *shapeNode = [self.nodeMap objectForKey:current];
        if ([shapeNode containsPoint:touchPoint]) {
            node = current;
        }
    }];

    return node;
}

- (BOOL)didHitAddButtonAtPoint:(CGPoint)point
{
    CGPoint touchPoint = [self adjustedPointForPoint:point];
    TCMindMapNode *selected = [self.nodeMap objectForKey:self.selectedNode];
    
    return [selected didHitAddButtonAtPoint:touchPoint];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    scale = 1.0 / _scrollView.maximumZoomScale;
}

- (void)userDidTouchViewAtPoint:(CGPoint)touchPoint
{
    switch (self.state) {
        case TCMindMapStateIdle:
        {
            TCNode *selected = [self nodeForPoint:touchPoint];
            if (selected) {
                self.selectedNode = selected;
                self.state = TCMindMapStateNodeSelected;
            }
            else {
                self.scrollView.scrollEnabled = YES;
            }

            return;
        }
        case TCMindMapStateNodeSelected:
        {
            if ([self didHitAddButtonAtPoint:touchPoint]) {
                self.state = TCMindMapStateCreatingNewNode;
                return;
            }

            TCNode *selected = [self nodeForPoint:touchPoint];
            if (!selected) {
                self.selectedNode = nil;
                self.state = TCMindMapStateIdle;
                return;
            }

            if (![self.selectedNode isEqual:selected]) {
                self.selectedNode = selected;
                return;
            }
            else {
            }
        }

        default:
            break;
    }
}

- (void)userDidMoveTouchInViewAtPoint:(CGPoint)touchPoint
{
    switch (self.state) {
        case TCMindMapStateIdle:
            return;
        case TCMindMapStateNodeSelected:
        {
            self.selectedNode.drawingData.centerPointString = NSStringFromCGPoint(touchPoint);
            break;
        }
        case TCMindMapStateCreatingNewNode:
        {
            self.newNodePathEndPoint = touchPoint;
            break;
        }

        default:
            break;
    }
}

- (void)userDidEndTouchInViewAtPoint:(CGPoint)touchPoint
{
    switch (self.state) {
        case TCMindMapStateIdle:
            break;
        case TCMindMapStateNodeSelected:
        {
            self.scrollView.scrollEnabled = YES;
            break;
        }
        case TCMindMapStateCreatingNewNode:
        {
            TCNode *newNode = [TCNode createNewUsingMainContextQueue:YES];
            newNode.parent = self.selectedNode;
            newNode.drawingData.centerPointString = NSStringFromCGPoint(touchPoint);
            newNode.name = [NSString stringWithFormat:@"New node: %d", arc4random() % 500];

            self.state = TCMindMapStateNodeSelected;
            [self addNode:newNode];
            self.selectedNode = newNode;

            SKShapeNode *path = [self pathNodeBetweenNode:newNode node:newNode.parent];
            [self.paths addObject:path];
            [self addChild:path];

            self.tempNode.hidden = YES;
            
            break;
        }

        default:
            break;
    }

    self.scrollView.scrollEnabled = YES;
}

- (CGPoint)adjustedPointForPoint:(CGPoint)point
{
    float s = self.scrollView.zoomScale * scale;
    return [self convertPointFromView:BKSubPoints(BKScalePoint1D(point, s), self.scrollView.contentOffset)];
}

- (UIBezierPath *)pathBetweenPoint:(CGPoint)p1 point:(CGPoint)p2
{
    float dy = (p2.y - p1.y);
    float k = 0.4;

    CGPoint c1 = BKAddPoints(p1, CGPointMake(0, k * dy));
    CGPoint c2 = BKAddPoints(p2, CGPointMake(0, -k * dy));
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:[self adjustedPointForPoint:p1]];
    [path addCurveToPoint:[self adjustedPointForPoint:p2] controlPoint1:[self adjustedPointForPoint:c1] controlPoint2:[self adjustedPointForPoint:c2]];

    return path;
}

- (void)drawPathForNodeCreationInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint p1 = [self adjustedPointForPoint:self.selectedNode.drawingData.center];
    CGPoint p2 = [self adjustedPointForPoint:self.newNodePathEndPoint];
    
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    
     float dash[2] = {2,3};
     CGContextSaveGState(context);
     CGContextSetLineDash(context, 0, dash, 2);
    
    [path stroke];
    
    CGContextRestoreGState(context);
}

- (SKShapeNode *)pathNodeBetweenNode:(TCNode *)node1 node:(TCNode *)node2
{
    SKShapeNode *path = [SKShapeNode node];
    path.strokeColor = [UIColor blackColor];
    path.lineWidth = 0.01;
    path.userData = @{@"node1": node1, @"node2": node2}.mutableCopy;

    return path;
}

- (void)updatePathNode:(SKShapeNode *)path
{
    TCNode *n1 = path.userData[@"node1"];
    TCNode *n2 = path.userData[@"node2"];
    UIBezierPath *bezierPath = [self pathBetweenPoint:n1.drawingData.center point:n2.drawingData.center];

    path.path = bezierPath.CGPath;
}

- (BOOL)shouldDrawNode:(TCNode *)node
{
    CGSize textBoundsIdealSize = [node.name sizeWithAttributes:@{NSFontAttributeName : self.defaultFont}];
    CGRect textBounds = (CGRect){CGPointZero, textBoundsIdealSize};
    
    CGRect base = BKCenterRect(BKScaleRect(textBounds, CGPointMake(1.5, 1.5)), node.drawingData.center);
    CGRect visible = [self.scrollView visibleContentFrame];

    return CGRectIntersectsRect(visible, base);
}

- (BOOL)shouldDrawPathFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2
{
    CGRect visible = [self.scrollView visibleContentFrame];

    return CGRectContainsPoint(visible, p1) || CGRectContainsPoint(visible, p2);
}

- (void)update:(NSTimeInterval)currentTime
{
    for (TCNode *current in self.topNode.allNodes) {
        
        TCMindMapNode *node = [self.nodeMap objectForKey:current];
        node.selected = [current isEqual:self.selectedNode];
        
        [node updateNodeWithOffset:self.scrollView.contentOffset scale:self.scrollView.zoomScale * scale];
    }

    for (SKShapeNode *path in self.paths) {
        [self updatePathNode:path];
    }

    if (self.state == TCMindMapStateCreatingNewNode) {
        self.tempNode.hidden = NO;
        self.tempNode.path = [self pathBetweenPoint:self.selectedNode.drawingData.center point:self.newNodePathEndPoint].CGPath;
    }
}

@end
