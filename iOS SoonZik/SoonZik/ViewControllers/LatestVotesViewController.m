//
//  LatestVotesViewController.m
//  SoonZik
//
//  Created by LLC on 30/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "LatestVotesViewController.h"

@interface LatestVotesViewController ()

@end

@implementation LatestVotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = nil;
   // [self.menuView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
