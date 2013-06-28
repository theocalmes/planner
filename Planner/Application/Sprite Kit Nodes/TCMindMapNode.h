//
//  TCMindMapNode.h
//  Planner
//
//  Created by Theodore Calmes on 6/28/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TCMindMapNode : SKShapeNode

@property (assign, nonatomic, getter = isSelected) BOOL selected;
@property (strong, nonatomic, readonly) TCNode *node;

- (instancetype)initWithNode:(TCNode *)node;
- (void)updateNodeWithOffset:(CGPoint)center scale:(float)scale;

- (BOOL)didHitAddButtonAtPoint:(CGPoint)touch;

@end
