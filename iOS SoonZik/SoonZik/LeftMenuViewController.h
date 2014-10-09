//
//  LeftMenuViewController.h
//  RoomForDay
//
//  Created by Maxime Sauvage on 23/09/2014.
//  Copyright (c) 2014 ok. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"

@interface LeftMenuViewController : AMSlideMenuLeftTableViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tabledata;

@end
