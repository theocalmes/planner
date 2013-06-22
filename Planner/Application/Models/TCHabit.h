//
//  TCHabit.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TCNode.h"


@interface TCHabit : TCNode

@property (nonatomic, retain) NSNumber * completedCount;
@property (nonatomic, retain) NSNumber * incompletedCount;
@property (nonatomic, retain) NSDate * lastCompleted;
@property (nonatomic, retain) NSNumber * streakCount;

@end
