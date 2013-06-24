//
//  TCMindMapViewController.m
//  Planner
//
//  Created by Theodore Calmes on 6/22/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCMindMapViewController.h"
#import "TCMindMapScrollView.h"

@interface TCMindMapViewController ()
@end

@implementation TCMindMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TCMindMapScrollView *scrollView = [[TCMindMapScrollView alloc] initWithFrame:self.view.bounds];
    
    

  //  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([TCNode class])];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"parent = nil"]];
/*
    NSArray *results = [[TCCoreDataStore mainQueueContext] executeFetchRequest:fetchRequest error:nil];
    TCNode *top = [results lastObject];
 */
    TCNode *top = [TCNode createNewUsingMainContextQueue:YES];
    top.name = @"Develop App";
    CGPoint center = CGPointMake(scrollView.contentSize.width /2.0, scrollView.contentSize.height/2.0);
    top.drawingData.centerPointString = NSStringFromCGPoint(center);

    scrollView.topNode = top;

    [self.view addSubview:scrollView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
