//
//  TCSpecificDaysSchedule.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/16/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCSchedule.h"

typedef enum : uint8_t {
    TCWeekDaySunday = 1 << 1,
    TCWeekDayMonday = 1 << 2,
    TCWeekDayTuesday = 1 << 3,
    TCWeekDayWednesday = 1 << 4,
    TCWeekDayThursday = 1 << 5,
    TCWeekDayFriday = 1 << 6,
    TCWeekDaySaturday = 1 << 7
} TCWeekDays;

@interface TCSpecificDaysSchedule : TCSchedule
@property (assign, nonatomic) TCWeekDays weekDays;
@end
