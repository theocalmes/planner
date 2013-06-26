//
//  TCMindMap.h
//  Planner
//
//  Created by Theodore Calmes on 6/22/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TCMindMapStateIdle,
    TCMindMapStateNodeSelected,
    TCMindMapStateCreatingNewNode,
    TCMindMapStateCreatedNewNode
} TCMindMapState;

@interface TCMindMap : UIView

@property (strong, nonatomic) TCNode *topNode;
@property (assign, nonatomic) TCMindMapState state;

@property (strong, nonatomic) UIScrollView *scrollView; 

- (void)userDidTouchViewAtPoint:(CGPoint)touchPoint;
- (void)userDidMoveTouchInViewAtPoint:(CGPoint)touchPoint;
- (void)userDidEndTouchInViewAtPoint:(CGPoint)touchPoint;

@end
