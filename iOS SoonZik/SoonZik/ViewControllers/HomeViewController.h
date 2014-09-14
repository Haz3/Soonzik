//
//  HomeViewController.h
//  SoonZik
//
//  Created by devmac on 26/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeViewController.h"
#import "AudioPlayer.h"
#import "Song.h"
#import "News.h"
#import "NewsTypeAlbumCell.h"

@interface HomeViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, NewsTypeAlbumDelegate>

@property (nonatomic, retain) AudioPlayer *player;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)loadPlaylist:(id)sender;

@end
