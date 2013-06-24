//
//  TCMindMapScrollView.h
//  Planner
//
//  Created by Theodore Calmes on 6/23/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCMindMap;

@interface TCMindMapScrollView : UIScrollView
@property (strong, nonatomic) TCNode *topNode;
@property (strong, nonatomic) TCMindMap *mindMap;

@end
