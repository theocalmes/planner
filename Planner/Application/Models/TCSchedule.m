//
//  TCSchedule.m
//  Planner
//
//  Created by Theodore Calmes on 6/28/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCSchedule.h"

@interface TCSchedule ()
@property (strong, nonatomic, readwrite) TCCalendar *calendar;
@end

@implementation TCSchedule

- (id)initWithCalendar:(TCCalendar *)calendar
{
    self = [super init];
    if (self) {
        _calendar = calendar;
    }

    return self;
}

- (NSInteger)streakCount {return 0;}
- (BOOL)shouldShowOnDate:(NSDate *)date {return NO;}
- (BOOL)isDueOnDate:(NSDate *)date {return NO;}
- (void)configureScheduleWithString:(NSString *)string {}
- (NSString *)stringValue {return nil;}

@end
