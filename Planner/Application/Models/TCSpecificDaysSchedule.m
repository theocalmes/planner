//
//  TCSpecificDaysSchedule.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/16/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCSpecificDaysSchedule.h"
#import "TCCalendar.h"
#import "NSDate+TCAdditions.h"

@implementation TCSpecificDaysSchedule

- (BOOL)shouldShowOnDate:(NSDate *)date
{
    return (bool)(self.weekDays & ( 1 << [date weekday]));
}

- (BOOL)isDueOnDate:(NSDate *)date
{
    return [self shouldShowOnDate:date];
}

- (void)configureScheduleWithString:(NSString *)string
{
    self.weekDays = [string intValue];
}

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%d", self.weekDays];
}

- (NSInteger)streakCount
{
    NSMutableSet *completionDateSet = [[NSMutableSet alloc] init];
    for (NSDate *date in self.calendar.completionDates) {
        [completionDateSet addObject:[self.calendar.dateFormatter stringFromDate:date]];
    }

    NSInteger streak = 0;

    NSDate *date = self.calendar.habit.creationDate;
    NSDate *endDate = self.calendar.completionDates.lastObject;
    while ([date isBeforeDate:endDate]) {
        NSString *dateString = [self.calendar.dateFormatter stringFromDate:date];

        if ([self isDueOnDate:date]) {
            if ([completionDateSet containsObject:dateString]) {
                streak++;
            }
            else {
                if (streak > 0) {
                    streak = 0;
                }
                else {
                    streak--;
                }
            }
        }

        date = [date dateThatIsNumberOfDaysAway:1];
    }
    
    return streak;
}

@end
