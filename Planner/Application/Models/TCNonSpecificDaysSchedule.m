//
//  TCNonSpecificDaysSchedule.m
//  Planner
//
//  Created by Theodore Calmes on 6/18/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCNonSpecificDaysSchedule.h"
#import "TCCalendar.h"
#import "NSDate+TCAdditions.h"

@implementation TCNonSpecificDaysSchedule

- (BOOL)isDueOnDate:(NSDate *)date
{
    return [self shouldShowOnDate:date];
}

- (BOOL)shouldShowOnDate:(NSDate *)date
{
    NSInteger currentDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];

    NSDateComponents *components = [[NSDateComponents alloc] init];

    components.day = 1 - currentDay;
    NSDate *lowDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];

    components.day = 7 - currentDay;
    NSDate *highDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];


    NSArray *completionsInWeek = [self.calendar.completionDates select:^BOOL(id obj) {
        NSDate *completionDate = (NSDate *)obj;
        return [completionDate isBetweenDate:lowDate andDate:highDate];
    }];

    return completionsInWeek.count < self.daysPerWeek;
}

- (void)configureScheduleWithString:(NSString *)string
{
    self.daysPerWeek = [string integerValue];
}

- (NSString *)stringValue
{
    return [@(self.daysPerWeek) stringValue];
}

- (NSInteger)streakCount
{
    return 0;
}

@end
