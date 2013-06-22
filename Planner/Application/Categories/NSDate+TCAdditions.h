//
//  NSDate+TCAdditions.h
//  Planner
//
//  Created by Theodore Calmes on 6/17/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TCAdditions)

+ (NSDate *)dateThatIsNumberOfDaysFromToday:(NSInteger)numberOfDays;
- (NSDate *)dateThatIsNumberOfDaysAway:(NSInteger)numberOfDays;

// Represents 00:00:00 on the following date
+ (NSDate *)tomorrow;

// Represents 00:00:00 on the previous date
+ (NSDate *)yesterday;

// Returns midnight for the current date
- (NSDate *)midnight;

- (NSInteger)weekday;

- (NSDateComponents *)dateComponents;

// Determines if the receiver falls between 00:00:00 and 23:59:59 for the current date
- (BOOL)isToday;
- (BOOL)isBeforeDate:(NSDate *)date;
- (BOOL)isAfterDate:(NSDate *)date;

@end
