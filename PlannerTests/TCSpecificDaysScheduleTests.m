//
//  TCSpecificDaysScheduleTests.m
//  Planner
//
//  Created by Theodore Calmes on 6/17/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TCSpecificDaysSchedule.h"
#import "NSDate+TCAdditions.h"

@interface TCSpecificDaysScheduleTests : XCTestCase

@end

@implementation TCSpecificDaysScheduleTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testDueDates
{
    TCSpecificDaysSchedule *schedule = [[TCSpecificDaysSchedule alloc] init];
    schedule.weekDays = TCWeekDayThursday | TCWeekDaySunday | TCWeekDayTuesday;

    NSDate *nextDueDate = schedule.nextDueDate;
    NSDate *lastDueDate = schedule.lastDueDate;

    BOOL nextDueDateShouldBeAfterLastDueDate = [nextDueDate isAfterDate:lastDueDate];
    BOOL nextDueDateWeekdayShouldBeInTheSchedule = schedule.weekDays & (1 << [nextDueDate weekday]);
    BOOL lastDueDateWeekdayShouldBeInTheSchedule = schedule.weekDays & (1 << [lastDueDate weekday]);

    XCTAssertTrue(nextDueDateShouldBeAfterLastDueDate, @"nextDueDate (%@) > lastDueDate (%@)", nextDueDate, lastDueDate);
    XCTAssertTrue(nextDueDateWeekdayShouldBeInTheSchedule, @"nextDueDate weekday %d = 1 or 3 or 5", [nextDueDate weekday]);
    XCTAssertTrue(lastDueDateWeekdayShouldBeInTheSchedule, @"lastDueDate weekday %d = 1 or 3 or 5", [lastDueDate weekday]);
}

@end
