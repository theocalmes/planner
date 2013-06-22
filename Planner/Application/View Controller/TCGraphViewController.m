//
//  TCGraphViewController.m
//  Planner
//
//  Created by Theodore Calmes on 6/21/13.
//  Copyright (c) 2013 theo. All rights reserved.
//

#import "TCGraphViewController.h"
#import "TCGraphView.h"


@interface TCGraphViewController ()
@property (strong, nonatomic) TCGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIView *graphViewContainer;

@end

@implementation TCGraphViewController

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
	// Do any additional setup after loading the view.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([TCNode class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"parent = nil"]];

    NSArray *results = [[TCCoreDataStore mainQueueContext] executeFetchRequest:fetchRequest error:nil];
    TCNode *top = [results lastObject];

    self.graphView = [[TCGraphView alloc] initWithFrame:self.graphViewContainer.bounds node:top];
    [self.graphViewContainer addSubview:self.graphView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self.graphView selector:@selector(calculate) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
