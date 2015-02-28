//
//  ContentViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"

@interface ContentViewController : TypeViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *playlistsCollectionView;

@property (nonatomic, strong) NSMutableArray *listOfPlaylists;
@property (nonatomic, strong) NSMutableArray *listOfAlbums;

@end
