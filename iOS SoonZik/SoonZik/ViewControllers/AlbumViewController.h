//
//  AlbumViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "Album.h"

@interface AlbumViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) NSMutableArray *listOfMusics;

@end
