//
//  TCNonSpecificDaysSchedule.h
//  Planner
//
//  Created by Theodore Calmes on 6/18/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCSchedulable.h"

@interface TCNonSpecificDaysSchedule : NSObject <TCSchedulable>

@property (strong, nonatomic) NSArray *allCompletionDates;
@property (assign, nonatomic) NSInteger daysPerWeek;

@end
