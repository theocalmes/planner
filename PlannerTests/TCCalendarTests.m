//
//  TCCalendarTests.m
//  Planner
//
//  Created by Theodore Calmes on 6/19/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TCCalendar.h"
#import "NSDate+TCAdditions.h"
#import "TCSpecificDaysSchedule.h"

@interface TCCalendarTests : XCTestCase

@end

@implementation TCCalendarTests

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

- (void)testSpecificDayCalendar
{
    TCCalendar *calendar = [[TCCalendar alloc] init];
    TCSpecificDaysSchedule *schedule = [[TCSpecificDaysSchedule alloc] init];
    schedule.weekDays = TCWeekDayMonday | TCWeekDayWednesday | TCWeekDayFriday;
    calendar.scheduler = schedule;

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:2013];
    [comps setMonth:1];
    [comps setDay:1];
    NSDate *startDate = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:comps];

    for (NSInteger i = 0; i < 10; i++) {
        [calendar.completionDates addObject:[startDate ]]
    }
    
    
}

@end
