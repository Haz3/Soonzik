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

@property (nonatomic, assign) int selectedRow;
@property (nonatomic, assign) int selectedSection;

@property (nonatomic, strong) CALayer *subLayer;
@property (nonatomic, strong) CALayer *imageLayer;

@end
