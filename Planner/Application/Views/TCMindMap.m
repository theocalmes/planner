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
@property (strong, nonatomic) NSMapTable *nodeToPathMap;
@property (strong, nonatomic) NSMapTable *nodeToImageMap;
@property (assign, nonatomic) CGPoint newNodePathEndPoint;
@property (assign, nonatomic) CGPoint newNodePathStartPoint;
@end

@implementation TCMindMap
{
    CGPoint debug;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nodeToPathMap = [NSMapTable strongToStrongObjectsMapTable];
        _nodeToImageMap = [NSMapTable strongToStrongObjectsMapTable];
        _state = TCMindMapStateIdle;
    }
    return self;
}

- (TCNode *)nodeForPoint:(CGPoint)point
{
    __block TCNode *node = nil;
    [self.topNode traverse:^(TCNode *current) {
        UIBezierPath *path = [self.nodeToPathMap objectForKey:current];
        if ([path containsPoint:point]) {
            node = current;
        }
    }];

    return node;
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

    [self userDidTouchViewAtPoint:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];

    [self userDidMoveTouchInViewAtPoint:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];

    [self userDidEndTouchInViewAtPoint:touchPoint];
    
}

- (UIBezierPath *)pathBetweenPoint:(CGPoint)p1 point:(CGPoint)p2
{
    float dy = (p2.y - p1.y);
    float k = 0.4;

    CGPoint c1 = BKAddPoints(p1, CGPointMake(0, k * dy));
    CGPoint c2 = BKAddPoints(p2, CGPointMake(0, -k * dy));
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:p1];
    [path addCurveToPoint:p2 controlPoint1:c1 controlPoint2:c2];

    return path;
}

- (void)drawNode:(TCNode *)node inContext:(CGContextRef)context
{
    CGPoint center = node.drawingData.center;
    NSString *name = node.name;

    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    CGRect textBounds = [name boundingRectWithSize:CGSizeMake(100, 44) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    textBounds = BKCenterRect(textBounds, center);

    CGRect shapeBase = BKScaleRect(textBounds, CGPointMake(1.3, 1.3));
    UIBezierPath *shape = [UIBezierPath bezierPathWithRoundedRect:shapeBase cornerRadius:2.5];
    shape.lineWidth = 3.0;
    
    if ([node isEqual:self.selectedNode]) {
        shape.lineWidth = 6.0;
        CGRect base = CGRectMake(0, 0, 10, 10);
        base = BKCenterRect(base, CGPointMake(CGRectGetMaxX(shapeBase) + 1.5 * base.size.width, CGRectGetMidY(shapeBase)));
        self.newNodePathStartPoint = BKRectCenter(base);
        
        UIBezierPath *newNodeButton = [UIBezierPath bezierPathWithOvalInRect:base];
        [[UIColor lightGrayColor] setFill];
        [newNodeButton fill];

        CGRect hitBox = CGRectMake(0, 0, 44, 44);
        hitBox = BKCenterRect(hitBox, CGPointMake(CGRectGetMaxX(shapeBase) + 22, CGRectGetMidY(shapeBase)));
        UIBezierPath *hitBoxPath = [UIBezierPath bezierPathWithRect:hitBox];
        self.selectedNodeAddButtonPath = hitBoxPath;
    }
    
    [[UIColor colorFromHexString:@"56cafc"] setFill];
    [[UIColor colorFromHexString:@"2F5AF9"] setStroke];
    
    [shape fill];
    [shape stroke];

    [name drawWithRect:textBounds options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];

    [self.nodeToPathMap setObject:shape forKey:node];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect visibleRect = [self.scrollView convertRect:self.scrollView.bounds toView:self];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];

    [self.topNode traverse:^(TCNode *current) {
        if (current.parent) {
            CGPoint p1 = CGPointFromString(current.drawingData.centerPointString);
            CGPoint p2 = CGPointFromString(current.parent.drawingData.centerPointString);
            UIBezierPath *path = [self pathBetweenPoint:p1 point:p2];
            [path stroke];
        }
    }];

    if (self.state == TCMindMapStateCreatingNewNode) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:self.selectedNode.drawingData.center];
        [path addLineToPoint:self.newNodePathEndPoint];
        /*
        float dash[2] = {2,3};
        CGContextSaveGState(context);
        CGContextSetLineDash(context, 0, dash, 2);
         */
        [path stroke];
        //CGContextRestoreGState(context);
    }

    [self.topNode traverse:^(TCNode *current) {
        UIBezierPath *path = [self.nodeToPathMap objectForKey:current];
        if (CGRectIntersectsRect(visibleRect, BKCenterRect(path.bounds, current.drawingData.center))) {
            [self drawNode:current inContext:context];
        }
    }];
/*
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        debug = self.topNode.drawingData.center;
    });

    CGRect box = CGRectMake(0, 0, 300, 300);
    box = BKCenterRect(box, debug);
    UIBezierPath *boxPath = [UIBezierPath bezierPathWithRect:box];
    [boxPath stroke];
 */
}

@end
