//
//  TCSchedule.h
//  Planner
//
//  Created by Theodore Calmes on 6/28/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCCalendar;

@interface TCSchedule : NSObject
@property (strong, nonatomic, readonly) TCCalendar *calendar;

- (instancetype)initWithCalendar:(TCCalendar *)calendar;

// Subclass
- (NSInteger)streakCount;
- (BOOL)shouldShowOnDate:(NSDate *)date;
- (BOOL)isDueOnDate:(NSDate *)date;
- (void)configureScheduleWithString:(NSString *)string;
- (NSString *)stringValue;

@end
