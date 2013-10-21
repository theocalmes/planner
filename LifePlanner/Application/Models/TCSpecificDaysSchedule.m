//
//  TCSpecificDaysSchedule.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/16/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCSpecificDaysSchedule.h"
#import "NSDate+RelativeDates.h"

@implementation TCSpecificDaysSchedule

- (NSDate *)nextDueDate
{
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];

    NSInteger daysTillDue = 0;
    for (NSInteger i = weekday; i <= 7; i++) {
        if (self.weekDays & (1 << i)) {
            daysTillDue = i - weekday;
        }
    }

    return [[NSDate dateThatIsNumberOfDaysFromToday:daysTillDue] midnight];
}

@end
