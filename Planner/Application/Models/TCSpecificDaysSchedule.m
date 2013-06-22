//
//  TCSpecificDaysSchedule.m
//  LifePlanner
//
//  Created by Theodore Calmes on 6/16/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCSpecificDaysSchedule.h"
#import "NSDate+TCAdditions.h"

@implementation TCSpecificDaysSchedule

- (BOOL)isDueOnDate:(NSDate *)date
{
    return (bool)(self.weekDays & ( 1 << [date weekday]));
}

- (NSDate *)nextDueDate
{
    NSInteger weekday = [[NSDate date] weekday];

    NSInteger daysTillDue = 0;
    for (NSInteger i = weekday; i <= 7; i++) {
        if (self.weekDays & (1 << ((7 + i) % 7))) {
            daysTillDue = i - weekday;
            break;
        }
    }

    return [[NSDate dateThatIsNumberOfDaysFromToday:daysTillDue] midnight];
}

- (NSDate *)lastDueDate
{
    NSInteger weekday = [[NSDate date] weekday];

    NSInteger daysTillDue = 0;
    for (NSInteger i = weekday - 1; i >= -7; i--) {
        if (i == 0) continue;
        
        if (self.weekDays & (1 << ((7 + i) % 7))) {
            daysTillDue = i - weekday;
            break;
        }
    }
    
    return [[NSDate dateThatIsNumberOfDaysFromToday:daysTillDue] midnight];
}

@end
