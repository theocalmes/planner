//
//  TCSchedule.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/16/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSchedule : NSObject
@property (strong, nonatomic) NSDate *nextDueDate;
@property (strong, nonatomic) NSDate *lastDueDate;
@end
