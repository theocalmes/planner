//
//  TCCalendar.m
//  Planner
//
//  Created by Theodore Calmes on 6/19/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCCalendar.h"
#import "NSDate+TCAdditions.h"

@interface TCCalendar ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation TCCalendar

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }

    return _dateFormatter;
}

- (NSInteger)streakCount
{
    NSMutableSet *completionDateSet = [[NSMutableSet alloc] init];
    for (NSDate *date in self.completionDates) {
        [completionDateSet addObject:[self.dateFormatter stringFromDate:date]];
    }

    NSInteger streak = 0;

    NSDate *date = self.habit.creationDate;
    NSDate *endDate = self.completionDates.lastObject;
    while ([date isBeforeDate:endDate]) {
        NSString *dateString = [self.dateFormatter stringFromDate:date];
        
        if ([self.scheduler isDueOnDate:date]) {
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
