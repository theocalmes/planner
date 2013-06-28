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

        self.mindMap = [[TCMindMap alloc] initWithSize:self.contentSize];
        self.mindMap.backgroundColor = [UIColor whiteColor];
        self.mindMap.scrollView = self;

        placeholder = [[UIView alloc] initWithFrame:self.mindMap.frame];
        [placeholder setBackgroundColor:[UIColor clearColor]];

        [self addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];

        [self addSubview:placeholder];
        //[self addSubview:self.mindMap];
    }
    return self;
}

static int cc = 0;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //[self.mindMap setNeedsDisplay];
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

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    ALog(@"");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self.mindMap setNeedsDisplay];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
   // [self.mindMap setNeedsDisplay];
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
