//
//  TCCalendar.h
//  Planner
//
//  Created by Theodore Calmes on 6/19/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCSchedule;

@interface TCCalendar : NSObject

@property (strong, nonatomic) NSMutableArray *completionDates;
@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) TCHabit *habit;
@property (strong, nonatomic) TCSchedule *schedule;

- (NSInteger)streakCount;
- (float)completionRatio;

@end
