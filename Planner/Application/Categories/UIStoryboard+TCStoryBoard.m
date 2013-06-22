//
//  UIStoryboard+TCStoryBoard.m
//  Planner
//
//  Created by Theodore Calmes on 6/21/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "UIStoryboard+TCStoryBoard.h"

@implementation UIStoryboard (TCStoryBoard)

+ (instancetype)storyboardInstance
{
    return [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

@end
