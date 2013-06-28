//
//  TCCalendar.m
//  Planner
//
//  Created by Theodore Calmes on 6/19/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCCalendar.h"
#import "TCSchedule.h"
#import "NSDate+TCAdditions.h"

@interface TCCalendar ()
@property (strong, nonatomic, readwrite) NSDateFormatter *dateFormatter;
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

@end
