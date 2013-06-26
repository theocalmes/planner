//
//  UIScrollView+TCAdditions.m
//  Planner
//
//  Created by Theodore Calmes on 6/24/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "UIScrollView+TCAdditions.h"

@implementation UIScrollView (TCAdditions)

- (CGRect)visibleContentFrame
{
    return (CGRect){self.contentOffset, self.contentSize};
}

@end
