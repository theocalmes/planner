//
//  TCHabitTask.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TCHabit.h"

@class TCTask;

@interface TCHabitTask : TCHabit

@property (nonatomic, retain) TCTask *task;

@end
