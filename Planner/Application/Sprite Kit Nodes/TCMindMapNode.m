//
//  TCMindMapNode.m
//  Planner
//
//  Created by Theodore Calmes on 6/28/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCMindMapNode.h"

#import "UIColor+Serialization.h"

@interface TCMindMapNode ()
@property (strong, nonatomic) SKShapeNode *addButton;
@property (strong, nonatomic) SKShapeNode *addButtonHitBox;
@end

@implementation TCMindMapNode

- (id)initWithNode:(TCNode *)node
{
    self = [super init];
    if (self) {
        _node = node;
        _selected = NO;
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    NSString *name = self.node.name;
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    CGSize textBoundsIdealSize = [name sizeWithAttributes:@{NSFontAttributeName : font}];
    CGRect textBounds = (CGRect){CGPointZero, textBoundsIdealSize};

    CGRect shapeBase = BKScaleRect1D(textBounds, 1.3);
    shapeBase.origin = CGPointZero;
    UIBezierPath *shape = [UIBezierPath bezierPathWithRoundedRect:shapeBase cornerRadius:2.5];

    self.zPosition = -100;
    self.lineWidth = 0.0;
    self.path = shape.CGPath;
    self.fillColor = [UIColor colorFromHexString:@"56cafc"];

    SKLabelNode *labelNode = [SKLabelNode node];
    labelNode.text = name;
    labelNode.position = BKSubPoints(BKRectCenter(shapeBase), CGPointMake(0, 0.45 * font.pointSize));
    labelNode.fontName = [font fontName];
    labelNode.fontSize = [font pointSize];
    [self addChild:labelNode];

    self.addButton = [SKShapeNode node];
    self.addButton.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)].CGPath;
    self.addButton.fillColor = [UIColor blueColor];
    self.addButton.strokeColor = [UIColor clearColor];
    self.addButton.lineWidth = 1.0;
    self.addButton.antialiased = YES;
    self.addButton.position = CGPointMake(CGRectGetMaxX(labelNode.frame) + 25, CGRectGetMidY(self.frame) - 10);
    self.addButton.hidden = YES;
    [self addChild:self.addButton];

    self.addButtonHitBox = [SKShapeNode node];

    CGRect hitBox = CGRectMake(0, 0, 44.0, CGRectGetHeight(self.frame));
    self.addButtonHitBox.path = [UIBezierPath bezierPathWithRect:hitBox].CGPath;
    self.addButtonHitBox.position = CGPointMake(CGRectGetMaxX(self.frame) + 5, 0);
    self.addButtonHitBox.hidden = YES;

    [self addChild:self.addButtonHitBox];
}

- (CGPoint)adjustedPointWithOffset:(CGPoint)offset scale:(float)scale
{
    return [self.scene convertPointFromView:BKSubPoints(BKScalePoint1D(self.node.drawingData.center, scale), offset)];
}

- (void)updateNodeWithOffset:(CGPoint)offset scale:(float)scale
{
    CGPoint center = [self adjustedPointWithOffset:offset scale:scale];
    self.position = BKSubPoints(center, CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0));
    self.xScale = scale;
    self.yScale = scale;

    if (self.isSelected) {
        [self setFillColor:[UIColor greenColor]];
        [self.addButton setHidden:NO];
    }
    else {
        [self setFillColor:[UIColor colorFromHexString:@"56cafc"]];
        [self.addButton setHidden:YES];
    }
}

- (BOOL)didHitAddButtonAtPoint:(CGPoint)touchPoint
{
    CGPoint relativePoint = [self convertPoint:touchPoint fromNode:self.scene];

    return [self.addButtonHitBox containsPoint:relativePoint];
}

@end
