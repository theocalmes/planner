//
//  TCDrawingData.m
//  Planner
//
//  Created by Theodore Calmes on 6/22/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCDrawingData.h"
#import "TCNode.h"


@implementation TCDrawingData

@dynamic centerPointString;
@dynamic node;

- (CGPoint)center
{
    return CGPointFromString(self.centerPointString);
}

@end
