//
//  FriendsViewController.h
//  SoonZik
//
//  Created by LLC on 09/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"

@interface FriendsViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listOfFriendsTitle;
@property (nonatomic, strong) NSMutableArray *listOfFriendsTMP;
@property (nonatomic, strong) NSMutableArray *listOfFirstLetter;
@property (nonatomic, strong) NSMutableDictionary *listOfFriends;

@property (nonatomic, weak) IBOutlet UIView *detailView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) CALayer *subLayer;
@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, assign) bool detailViewOpen;

@end
