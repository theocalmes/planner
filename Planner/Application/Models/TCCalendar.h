//
//  TCCalendar.h
//  Planner
//
//  Created by Theodore Calmes on 6/19/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCSchedulable.h"

@interface TCCalendar : NSObject

@property (strong, nonatomic) NSMutableArray *completionDates;
@property (strong, nonatomic) TCHabit *habit;
@property (strong, nonatomic) id <TCSchedulable> scheduler;

- (NSInteger)streakCount;
- (float)completionRatio;

@end
