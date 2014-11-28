//
//  PackViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 08/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "HeaderPackView.h"

@interface PackViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, SlidePacksDelegate>

@property (nonatomic, strong) NSArray *listOfPacks;

@property (nonatomic, weak) IBOutlet UILabel *packLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *blurView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CALayer *subLayer;

@property (nonatomic, assign) int indexOfPage;

@end
