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
static const float kMaximumZoomScale = 6.0;

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
        
        CGSize viewSize = frame.size;
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

        self.mindMap = [[TCMindMap alloc] initWithFrame:contentFrame];
        self.mindMap.backgroundColor = [UIColor whiteColor];
        self.mindMap.scrollView = self;

        placeholder = [[UIView alloc] initWithFrame:self.mindMap.frame];
        [placeholder setBackgroundColor:[UIColor clearColor]];

        [self addSubview:placeholder];
        //[self addSubview:self.mindMap];
    }
    return self;
}

- (void)setTopNode:(TCNode *)topNode
{
    _topNode = topNode;
    self.mindMap.topNode = topNode;
    self.contentOffset = BKSubPoints(topNode.drawingData.center, CGPointMake(50, 50));
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
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mindMap];
    [self.mindMap userDidTouchViewAtPoint:touchPoint];

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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.mindMap setNeedsDisplay];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self.mindMap setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
