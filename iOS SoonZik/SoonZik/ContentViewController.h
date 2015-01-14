//
//  ContentViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "WYPopoverController.h"
#import "AddPlaylistViewController.h"

@interface ContentViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, WYPopoverControllerDelegate, ClosePopupDelegate>
{
    WYPopoverController *popoverController;
}

@property (nonatomic, weak) IBOutlet UICollectionView *playlistsCollectionView;
@property (nonatomic, weak) IBOutlet UITableView *albumsTableView;
@property (nonatomic, weak) IBOutlet UIScrollView *horizontalScrollView;
@property (nonatomic, weak) IBOutlet UIView *horizontalContentView;

@property (nonatomic, strong) NSMutableArray *listOfPlaylists;
@property (nonatomic, strong) NSMutableArray *listOfAlbums;

@property (nonatomic, weak) IBOutlet UIButton *playlistButton;
@property (nonatomic, weak) IBOutlet UIButton *albumsButton;
@property (nonatomic, weak) IBOutlet UIView *movableView;

@property (nonatomic, assign) int index;

@property (nonatomic, strong) AddPlaylistViewController *addPlaylistVC;

@end
