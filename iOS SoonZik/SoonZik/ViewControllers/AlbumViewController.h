//
//  AlbumViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "AudioPlayer.h"

@interface AlbumViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) AudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *listOfMusics;

@end
