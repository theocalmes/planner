//
//  NSDate+TCAdditions.m
//  Planner
//
//  Created by Theodore Calmes on 6/17/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "NSDate+TCAdditions.h"

@implementation NSDate (TCAdditions)

+ (NSDate *)tomorrow
{
    return [[NSDate dateThatIsNumberOfDaysFromToday:1] midnight];
}

+ (NSDate *)yesterday
{
    return [[NSDate dateThatIsNumberOfDaysFromToday:-1] midnight];
}

- (NSDate *)midnight
{
    NSDateComponents *components = [self dateComponents];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;

    return [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
}

- (NSInteger)weekday
{
    NSDateComponents *comps = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    return [comps weekday];
}

- (NSInteger)weekNumber
{
    NSDateComponents *comps = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekCalendarUnit fromDate:self];
    return [comps week];
}

- (BOOL)isToday
{
    if ([self compare:[NSDate yesterday]] == NSOrderedDescending && [self compare:[NSDate tomorrow]] == NSOrderedAscending)
        return YES;

    return NO;
}

- (BOOL)isBeforeDate:(NSDate *)date
{
    if ([self compare:date] == NSOrderedAscending)
        return YES;

    return NO;
}

- (BOOL)isAfterDate:(NSDate *)date
{
    if ([self compare:date] == NSOrderedDescending)
        return YES;

    return NO;
}

- (BOOL)isBetweenDate:(NSDate *)low andDate:(NSDate *)high
{
    NSInteger lowOrder = [self compare:low];
    NSInteger highOrder = [self compare:high];

    return (lowOrder == NSOrderedSame || lowOrder == NSOrderedDescending) && (highOrder == NSOrderedSame || highOrder == NSOrderedAscending);
}

+ (NSDate *)dateThatIsNumberOfDaysFromToday:(NSInteger)numberOfDays
{
    NSDateComponents *components = [[NSDate date] dateComponents];
    components.day = components.day + numberOfDays;

    return [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
}

- (NSDate *)dateThatIsNumberOfDaysAway:(NSInteger)numberOfDays
{
    NSDateComponents *components = [self dateComponents];
    components.day = components.day + numberOfDays;

    return [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
}

- (NSDateComponents *)dateComponents
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger componentUnitFlags = (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
    NSDateComponents *dateComponents = [calendar components:componentUnitFlags fromDate:self];

    return dateComponents;
}

@end
