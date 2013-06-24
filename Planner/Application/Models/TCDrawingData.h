//
//  TCDrawingData.h
//  Planner
//
//  Created by Theodore Calmes on 6/22/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TCNode;

@interface TCDrawingData : NSManagedObject

@property (nonatomic, retain) NSString * centerPointString;
@property (nonatomic, retain) TCNode *node;

@property (nonatomic, assign, readonly) CGPoint center;

@end
