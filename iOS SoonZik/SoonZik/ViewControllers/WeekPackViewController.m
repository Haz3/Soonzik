//
//  WeekPackViewController.m
//  SoonZik
//
//  Created by LLC on 02/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "WeekPackViewController.h"

@interface WeekPackViewController ()

@end

@implementation WeekPackViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self.contentView layoutIfNeeded];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:222/255.0f green:222/255.0f blue:222/255.0f alpha:1.0f]];
    CGSize size = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height + self.playerPreviewView.frame.size.height);
    self.scrollView.contentSize = size;
    [self.scrollView addSubview:self.contentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
