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
@property (strong, nonatomic) NSMapTable *nodeToShapeNodeMap;
@property (assign, nonatomic) CGPoint newNodePathEndPoint;
@property (assign, nonatomic) CGPoint newNodePathStartPoint;
@property (strong, nonatomic) UIFont *defaultFont;
@property (strong, nonatomic) NSMutableArray *paths;
@property (strong, nonatomic) SKShapeNode *tempNode;
@end

@implementation TCMindMap
{
    CGPoint debug;
    float scale;
}
/*
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
 */
- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _nodeToHitBoxPathMap = [NSMapTable strongToStrongObjectsMapTable];
        _nodeToDrawingPathMap = [NSMapTable strongToStrongObjectsMapTable];
        _nodeToShapeNodeMap = [NSMapTable strongToStrongObjectsMapTable];
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
    [self addChild:[self nodeFromNode:_topNode]];
}

- (TCNode *)nodeForPoint:(CGPoint)point
{
    CGPoint touchPoint = [self adjustedPointForPoint:point];
    __block TCNode *node = nil;
    [self.topNode traverse:^(TCNode *current) {
        SKShapeNode *shapeNode = [self.nodeToDrawingPathMap objectForKey:current];
        if ([shapeNode containsPoint:touchPoint]) {
            node = current;
        }
    }];

    return node;
}

- (BOOL)didHitAddButtonAtPoint:(CGPoint)point
{
    CGPoint touchPoint = [self adjustedPointForPoint:point];
    SKShapeNode *addButton = [self.nodeToHitBoxPathMap objectForKey:self.selectedNode];
    CGPoint relativePoint = [[self.nodeToShapeNodeMap objectForKey:self.selectedNode] convertPoint:touchPoint fromNode:self];

    return [addButton containsPoint:relativePoint];
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
               //[self setNeedsDisplay];
                return;
            }

            if (![self.selectedNode isEqual:selected]) {
                self.selectedNode = selected;
                //[self setNeedsDisplay];
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
            //[self setNeedsDisplay];
            break;
        }
        case TCMindMapStateCreatingNewNode:
        {
            self.newNodePathEndPoint = touchPoint;
            //[self setNeedsDisplay];
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
            //[self setNeedsDisplay];
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
            [self addChild:[self nodeFromNode:newNode]];

            SKShapeNode *path = [self pathNodeBetweenNode:newNode node:newNode.parent];
            [self.paths addObject:path];
            [self addChild:path];

            self.tempNode.hidden = YES;
            
            //[self setNeedsDisplay];

            break;
        }

        default:
            break;
    }

    self.scrollView.scrollEnabled = YES;
}
/*
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
 */

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
/*
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
 */
- (SKNode *)nodeFromNode:(TCNode *)node
{
    CGPoint center = node.drawingData.center;
    NSString *name = node.name;
    
    UIFont *font = [self.defaultFont fontWithSize:(self.defaultFont.pointSize)];

    CGSize textBoundsIdealSize = [name sizeWithAttributes:@{NSFontAttributeName : font}];
    CGRect textBounds = (CGRect){CGPointZero, textBoundsIdealSize};

    CGRect shapeBase = BKScaleRect1D(textBounds, 1.3);
    shapeBase.origin = CGPointZero;
    UIBezierPath *shape = [UIBezierPath bezierPathWithRoundedRect:shapeBase cornerRadius:2.5];
    //shape.lineWidth = 3.0;

    SKShapeNode *shapeNode = [SKShapeNode node];
    shapeNode.zPosition = -100;
    shapeNode.lineWidth = 0.0;
    shapeNode.path = shape.CGPath;
    shapeNode.fillColor = [UIColor colorFromHexString:@"56cafc"];

    SKLabelNode *labelNode = [SKLabelNode node];
    labelNode.text = node.name;
    labelNode.position = BKSubPoints(BKRectCenter(shapeBase), CGPointMake(0, 0.45 * font.pointSize));
    labelNode.fontName = [font fontName];
    labelNode.fontSize = [font pointSize];
    [shapeNode addChild:labelNode];

    SKShapeNode *addButton = [SKShapeNode node];
    addButton.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)].CGPath;
    addButton.fillColor = [UIColor blueColor];
    addButton.position = CGPointMake(CGRectGetMaxX(labelNode.frame) + 15, CGRectGetMidY(shapeNode.frame) - 10);
    addButton.hidden = YES;
    [shapeNode addChild:addButton];

    [self.nodeToHitBoxPathMap setObject:addButton forKey:node];
    [self.nodeToShapeNodeMap setObject:shapeNode forKey:node];
    [self.nodeToDrawingPathMap setObject:shapeNode forKey:node];

    return shapeNode;
}

- (SKShapeNode *)pathNodeBetweenNode:(TCNode *)node1 node:(TCNode *)node2
{
    SKShapeNode *path = [SKShapeNode node];
    path.strokeColor = [UIColor blackColor];
    path.lineWidth = 0.1;
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
        SKShapeNode *node = [self.nodeToDrawingPathMap objectForKey:current];
        CGPoint center = [self adjustedPointForPoint:current.drawingData.center];
        node.position = BKSubPoints(center, CGPointMake(node.frame.size.width / 2.0, node.frame.size.height / 2.0));
        node.xScale = self.scrollView.zoomScale * scale;
        node.yScale = self.scrollView.zoomScale * scale;

        if ([current isEqual:self.selectedNode]) {
            SKShapeNode *shape = [self.nodeToShapeNodeMap objectForKey:current];
            [shape setFillColor:[UIColor greenColor]];
            [(SKShapeNode *)[self.nodeToHitBoxPathMap objectForKey:current] setHidden:NO];
        }
        else {
            SKShapeNode *shape = [self.nodeToShapeNodeMap objectForKey:current];
            [shape setFillColor:[UIColor blueColor]];
            [(SKShapeNode *)[self.nodeToHitBoxPathMap objectForKey:current] setHidden:YES];
        }
        //}
    }

    for (SKShapeNode *path in self.paths) {
        [self updatePathNode:path];
    }

    if (self.state == TCMindMapStateCreatingNewNode) {
        self.tempNode.hidden = NO;
        self.tempNode.path = [self pathBetweenPoint:self.selectedNode.drawingData.center point:self.newNodePathEndPoint].CGPath;
    }
}

/*
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
 */

@end
