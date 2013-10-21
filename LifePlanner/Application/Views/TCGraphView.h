//
//  TCGraphView.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCGraphView : UIView

- (id)initWithFrame:(CGRect)frame node:(TCNode *)node;

- (void)calculate;

@end
