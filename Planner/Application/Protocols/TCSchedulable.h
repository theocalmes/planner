//
//  TCSchedulable.h
//  Planner
//
//  Created by Theodore Calmes on 6/18/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCSchedulable <NSObject>
@required
- (BOOL)isDueOnDate:(NSDate *)date;
@optional
@property (strong, nonatomic, readonly) NSDate *lastDueDate;
@property (strong, nonatomic, readonly) NSDate *nextDueDate;
@end
