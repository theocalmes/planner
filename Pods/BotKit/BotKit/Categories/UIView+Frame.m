//
//  UIView+Frame.m
//  BotKit
//
//  Created by theo on 4/16/13.
//  Copyright (c) 2013 thoughtbot. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - Origin Manipulation

- (void)setOrigin:(CGPoint)origin
{
    CGRect newFrame = CGRectMake(origin.x, origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));

    self.frame = newFrame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setX:(CGFloat)x
{
    [self setOrigin:CGPointMake(x, CGRectGetMinY(self.frame))];
}

- (void)setY:(CGFloat)y
{
    [self setOrigin:CGPointMake(CGRectGetMinX(self.frame), y)];
}

- (void)setX:(CGFloat)x Y:(CGFloat)y
{
    [self setOrigin:CGPointMake(x, y)];
}

- (void)addToX:(CGFloat)amount
{
    [self addToX:amount Y:0];
}

- (void)addToY:(CGFloat)amount
{
    [self addToX:0 Y:amount];
}

- (void)addToX:(CGFloat)xAmount Y:(CGFloat)yAmount
{
    CGPoint origin = [self origin];
    origin.x += xAmount;
    origin.y += yAmount;

    [self setOrigin:origin];
}

#pragma mark - Size Manipulation

- (void)setSize:(CGSize)size
{
    CGRect newFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), size.width, size.height);

    self.frame = newFrame;
}

- (CGSize)size
{
    return self.bounds.size;
}

- (void)setWidth:(CGFloat)width
{
    [self setSize:CGSizeMake(width, CGRectGetHeight(self.bounds))];
}

- (void)setHeight:(CGFloat)height
{
    [self setSize:CGSizeMake(CGRectGetWidth(self.bounds), height)];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height
{
    [self setSize:CGSizeMake(width, height)];
}

- (void)addToWith:(CGFloat)amount
{
    [self addToWidth:amount height:0];
}

- (void)addToHeight:(CGFloat)amount
{
    [self addToWidth:0 height:amount];
}

- (void)addToWidth:(CGFloat)widthAmount height:(CGFloat)heightAmount
{
    CGSize size = [self size];
    size.width += widthAmount;
    size.height += heightAmount;

    [self setSize:size];
}

#pragma mark - Other Manipulation

- (void)setTopLeftPoint:(CGPoint)topLeft bottomRightPoint:(CGPoint)bottomRight
{
    CGRect newFrame = CGRectMake(topLeft.x, topLeft.y, bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);
    self.frame = newFrame;
}

@end
