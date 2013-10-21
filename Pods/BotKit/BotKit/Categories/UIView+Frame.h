//
//  UIView+Frame.h
//  BotKit
//
//  Created by theo on 4/16/13.
//  Copyright (c) 2013 thoughtbot. All rights reserved.
//

static CGPoint BKRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static CGRect BKCenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGPoint BKAddPoints(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

static CGRect BKAddRects(CGRect r1, CGRect r2)
{
    return CGRectMake(r1.origin.x + r2.origin.x,
                      r1.origin.y + r2.origin.y,
                      r1.size.width + r2.size.width,
                      r1.size.height + r2.size.height);
}

static CGRect BKAddPointToRect(CGRect rect, CGPoint point)
{
    return CGRectMake(rect.origin.x + point.x, rect.origin.y + point.y, rect.size.width, rect.size.height);
}

static CGRect BKAddSizeToRect(CGRect rect, CGSize size)
{
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + size.width, rect.size.height + rect.size.height);
}

static CGRect BKRectFromPoints(CGPoint top, CGPoint bottom)
{
    return CGRectMake(top.x, top.y, bottom.x - top.x, bottom.y - top.y);
}

static CGPoint BKTopLeftCorner(CGRect rect)
{
    return rect.origin;
}

static CGPoint BKTopRightCorner(CGRect rect)
{
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

static CGPoint BKBottomLeftCorner(CGRect rect)
{
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

static CGPoint BKBottomRightCorner(CGRect rect)
{
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

static CGRect BKScaleRect(CGRect rect, CGPoint scale)
{
    CGPoint iniCenter = BKRectCenter(rect);
    CGRect scaled = CGRectMake(0, 0, rect.size.width*scale.x, rect.size.height*scale.y);
    return BKCenterRect(scaled, iniCenter);
}


@interface UIView (Frame)

- (void)setOrigin:(CGPoint)origin;
- (CGPoint)origin;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x Y:(CGFloat)y;
- (void)addToX:(CGFloat)amount;
- (void)addToY:(CGFloat)amount;
- (void)addToX:(CGFloat)xAmount Y:(CGFloat)yAmount;

- (void)setSize:(CGSize)size;
- (CGSize)size;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width height:(CGFloat)height;
- (void)addToWith:(CGFloat)amount;
- (void)addToHeight:(CGFloat)amount;
- (void)addToWidth:(CGFloat)widthAmount height:(CGFloat)heightAmount;

- (void)setTopLeftPoint:(CGPoint)topLeft bottomRightPoint:(CGPoint)bottomRight;

@end
