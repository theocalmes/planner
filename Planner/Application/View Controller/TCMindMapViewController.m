//
//  TCMindMapViewController.m
//  Planner
//
//  Created by Theodore Calmes on 6/22/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCMindMapViewController.h"
#import "TCMindMapScrollView.h"
#import "TCMindMap.h"

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
    [scrollView setZoomScale:6.0 animated:YES];

  //  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([TCNode class])];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"parent = nil"]];
/*
    NSArray *results = [[TCCoreDataStore mainQueueContext] executeFetchRequest:fetchRequest error:nil];
    TCNode *top = [results lastObject];
 */
    TCNode *top = [TCNode createNewUsingMainContextQueue:YES];
    top.name = @"Develop App";
    CGPoint center = CGPointMake(scrollView.mindMap.size.width * 6.0 /2.0, scrollView.mindMap.size.height * 6.0 /2.0);
    top.drawingData.centerPointString = NSStringFromCGPoint(center);

    scrollView.topNode = top;

    SKView *gameView = [[SKView alloc] initWithFrame:scrollView.frame];
    [gameView presentScene:scrollView.mindMap];

    [self.view addSubview:gameView];

    //[self.view addSubview:scrollView.mindMap];
    [self.view addSubview:scrollView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
