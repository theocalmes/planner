//
//  TCMindMapScrollView.m
//  Planner
//
//  Created by Theodore Calmes on 6/23/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCMindMapScrollView.h"
#import "TCMindMap.h"

static const float kMinimumZoomScale = 1.0;
static const float kMaximumZoomScale = 5.0;

@interface TCMindMapScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end

@implementation TCMindMapScrollView
{
    UIView *placeholder;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect contentFrame = self.bounds;
        self.contentSize = contentFrame.size;
        self.delegate = self;
        self.maximumZoomScale = kMaximumZoomScale;
        self.minimumZoomScale = kMinimumZoomScale;
        self.canCancelContentTouches = NO;
        self.multipleTouchEnabled = YES;
        [self setZoomScale:5.0 animated:YES];

        CGPoint start = BKCenterRect(frame, BKRectCenter(contentFrame)).origin;
        self.contentOffset = start;

        self.mindMap = [[TCMindMap alloc] initWithSize:self.contentSize];
        self.mindMap.backgroundColor = [UIColor whiteColor];
        self.mindMap.scrollView = self;

        placeholder = [[UIView alloc] initWithFrame:self.mindMap.frame];
        [placeholder setBackgroundColor:[UIColor clearColor]];

        [self addSubview:placeholder];
    }
    return self;
}

- (void)setTopNode:(TCNode *)topNode
{
    _topNode = topNode;
    self.mindMap.topNode = topNode;
    self.contentOffset = BKAddPoints(topNode.drawingData.center, CGPointMake(200, 200));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return placeholder;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.scrollEnabled = YES;
        return YES;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    [self.mindMap userDidTouchViewAtPoint:BKScalePoint1D(touchPoint, self.maximumZoomScale / self.zoomScale)];

    if (self.mindMap.state == TCMindMapStateIdle) {
        return YES;
    }
    else {
        self.scrollEnabled = NO;
        return NO;
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];

    [self.mindMap userDidTouchViewAtPoint:BKScalePoint1D(touchPoint, self.maximumZoomScale / self.zoomScale)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];

    [self.mindMap userDidMoveTouchInViewAtPoint:BKScalePoint1D(touchPoint, self.maximumZoomScale / self.zoomScale)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.mindMap userDidEndTouchInViewAtPoint:BKScalePoint1D(touchPoint, self.maximumZoomScale / self.zoomScale)];
}

@end
