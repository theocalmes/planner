//
//  TCTask.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TCNode.h"


@interface TCTask : TCNode

@property (nonatomic, retain) NSNumber * completionState;
@property (nonatomic, retain) NSDate * dueDate;

@end
