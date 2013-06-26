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

float d(CGPoint a, CGPoint b)
{
    return sqrtf(powf(a.x - b.x, 2) + powf(a.y - b.y, 2));
}

@interface TCMindMap ()
@property (strong, nonatomic) TCNode *selectedNode;
@property (strong, nonatomic) UIBezierPath *selectedNodeAddButtonPath;
@property (strong, nonatomic) NSMapTable *nodeToHitBoxPathMap;
@property (strong, nonatomic) NSMapTable *nodeToDrawingPathMap;
@property (assign, nonatomic) CGPoint newNodePathEndPoint;
@property (assign, nonatomic) CGPoint newNodePathStartPoint;
@property (strong, nonatomic) UIFont *defaultFont;
@end

@implementation TCMindMap
{
    CGPoint debug;
    float scale;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nodeToHitBoxPathMap = [NSMapTable strongToStrongObjectsMapTable];
        _nodeToDrawingPathMap = [NSMapTable strongToStrongObjectsMapTable];
        _state = TCMindMapStateIdle;
        _defaultFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return self;
}

- (TCNode *)nodeForPoint:(CGPoint)point
{
    __block TCNode *node = nil;
    [self.topNode traverse:^(TCNode *current) {
        UIBezierPath *path = [self.nodeToHitBoxPathMap objectForKey:current];
        if ([path containsPoint:point]) {
            node = current;
        }
    }];

    return node;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    scale = 1.0 / _scrollView.maximumZoomScale;
}

- (void)userDidTouchViewAtPoint:(CGPoint)touchPoint
{
    //NSLog(@"point %@, node: %@", NSStringFromCGPoint(touchPoint), self.topNode.drawingData.centerPointString);
    switch (self.state) {
        case TCMindMapStateIdle:
        {
            TCNode *selected = [self nodeForPoint:touchPoint];
            if (selected) {
                self.selectedNode = selected;
                self.state = TCMindMapStateNodeSelected;
                [self setNeedsDisplay];
            }
            else {
                self.scrollView.scrollEnabled = YES;
            }

            return;
        }
        case TCMindMapStateNodeSelected:
        {
            if ([self.selectedNodeAddButtonPath containsPoint:touchPoint]) {
                self.state = TCMindMapStateCreatingNewNode;
                return;
            }

            TCNode *selected = [self nodeForPoint:touchPoint];
            if (!selected) {
                self.selectedNode = nil;
                self.state = TCMindMapStateIdle;
                [self setNeedsDisplay];
                return;
            }

            if (![self.selectedNode isEqual:selected]) {
                self.selectedNode = selected;
                [self setNeedsDisplay];
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
            [self setNeedsDisplay];
            break;
        }
        case TCMindMapStateCreatingNewNode:
        {
            self.newNodePathEndPoint = touchPoint;
            [self setNeedsDisplay];
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
            [self setNeedsDisplay];
            break;
        }
        case TCMindMapStateCreatingNewNode:
        {
            TCNode *newNode = [TCNode createNewUsingMainContextQueue:YES];
            newNode.parent = self.selectedNode;
            newNode.drawingData.centerPointString = NSStringFromCGPoint(touchPoint);
            newNode.name = [NSString stringWithFormat:@"New node: %d", arc4random() % 500];

            self.state = TCMindMapStateNodeSelected;
            self.selectedNode = newNode;

            [self setNeedsDisplay];

            break;
        }

        default:
            break;
    }

    self.scrollView.scrollEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];

    touchPoint = [self.scrollView convertPoint:touchPoint fromView:self];

    [self userDidTouchViewAtPoint:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];

    touchPoint = [self.scrollView convertPoint:touchPoint fromView:self];

    [self userDidMoveTouchInViewAtPoint:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];

    touchPoint = [self.scrollView convertPoint:touchPoint fromView:self];

    [self userDidEndTouchInViewAtPoint:touchPoint];
    
}

- (CGPoint)adjustedPointForPoint:(CGPoint)point
{
    float s = self.scrollView.zoomScale * scale;
    return BKSubPoints(BKScalePoint1D(point, s), self.scrollView.contentOffset);
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

- (void)drawNode:(TCNode *)node inContext:(CGContextRef)context
{
    CGPoint center = node.drawingData.center;
    NSString *name = node.name;

    float s = self.scrollView.zoomScale * scale;
    center = BKSubPoints(BKScalePoint1D(center, s), self.scrollView.contentOffset);

    UIFont *font = [self.defaultFont fontWithSize:(self.defaultFont.pointSize * s)];

    CGSize textBoundsIdealSize = [name sizeWithAttributes:@{NSFontAttributeName : font}];
    CGRect textBounds = (CGRect){CGPointZero, textBoundsIdealSize};

    //CGSize textBoundsIdealSize = CGSizeMake(s * 100, s * 44);
    //CGRect textBounds = [name boundingRectWithSize:textBoundsIdealSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    textBounds = BKCenterRect(textBounds, center);

    CGRect shapeBase = BKScaleRect1D(textBounds, 1.3);
    UIBezierPath *shape = [UIBezierPath bezierPathWithRoundedRect:shapeBase cornerRadius:2.5];
    shape.lineWidth = 3.0;

    CGRect hitBoxRect = BKScaleRect1D(BKCenterRect(shapeBase, node.drawingData.center), 1.4 / s);
    UIBezierPath *hitBoxPath = [UIBezierPath bezierPathWithRect:hitBoxRect];
    [self.nodeToHitBoxPathMap setObject:hitBoxPath forKey:node];

    if ([node isEqual:self.selectedNode]) {
        shape.lineWidth = 6.0;
        CGRect base = CGRectMake(0, 0, 10 * s, 10 * s);
        base = BKCenterRect(base, CGPointMake(CGRectGetMaxX(shapeBase) + 1.5 * base.size.width, CGRectGetMidY(shapeBase)));
        self.newNodePathStartPoint = BKRectCenter(base);
        
        UIBezierPath *newNodeButton = [UIBezierPath bezierPathWithOvalInRect:base];
        [[UIColor lightGrayColor] setFill];
        [newNodeButton fill];

        CGRect addButtonHitBoxRect = CGRectMake(0, 0, 44 * s, 44 * s);
        addButtonHitBoxRect = BKCenterRect(addButtonHitBoxRect, CGPointMake(CGRectGetMaxX(hitBoxRect) + 22 * s, CGRectGetMidY(hitBoxRect)));
        UIBezierPath *addButtonHitBoxPath = [UIBezierPath bezierPathWithRect:addButtonHitBoxRect];
        self.selectedNodeAddButtonPath = addButtonHitBoxPath;
    }
    
    [[UIColor colorFromHexString:@"56cafc"] setFill];
    [[UIColor colorFromHexString:@"2F5AF9"] setStroke];

    [shape fill];
    [shape stroke];

    [name drawWithRect:textBounds options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];

    [self.nodeToDrawingPathMap setObject:shape forKey:node];
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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    TIMER_BEGIN
    [self.topNode traverse:^(TCNode *current) {
        if (current.parent) {
            CGPoint p1 = CGPointFromString(current.drawingData.centerPointString);
            CGPoint p2 = CGPointFromString(current.parent.drawingData.centerPointString);
            UIBezierPath *path = [self pathBetweenPoint:p1 point:p2];
            [path stroke];
        }
    }];

    if (self.state == TCMindMapStateCreatingNewNode) {
        [self drawPathForNodeCreationInContext:context];
    }

    for (TCNode *current in self.topNode.allNodes) {
        if ([self shouldDrawNode:current]) {
            [self drawNode:current inContext:context];
        }
    }
    TIMER_LOG
}

@end
