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
#import "Music.h"
#import "News.h"
#import "User.h"
#import "Album.h"
#import "NewsTypeAlbumCell.h"
#import "AAShareBubbles.h"

@interface HomeViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, ShareNewsDelegate, AAShareBubblesDelegate>

@property (nonatomic, retain) AudioPlayer *player;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listOfNews;

- (IBAction)loadPlaylist:(id)sender;

@end
