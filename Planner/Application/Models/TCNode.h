//
//  TCNode.h
//  LifePlanner
//
//  Created by Theodore Calmes on 6/9/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TCNode;
@class TCPhysicsGraph;
@class TCDrawingData;

typedef void(^TCApply)(TCNode *current);

@interface TCNode : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * detailedDescription;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) TCNode *parent;
@property (nonatomic, retain) TCDrawingData *drawingData;

- (void)traverse:(TCApply)applyBlock;

- (NSSet *)leaves;
- (NSSet *)branches;
- (NSSet *)allNodes;

- (NSUInteger)depth;

- (TCPhysicsGraph *)graph;


@end

@interface TCNode (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(TCNode *)value;
- (void)removeChildrenObject:(TCNode *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
