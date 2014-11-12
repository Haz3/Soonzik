//
//  ArtistViewController.h
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeViewController.h"

@interface ArtistViewController : TypeViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (weak, nonatomic) IBOutlet UIView *horizontalContentView;

@property (nonatomic, assign) int index;

@property (weak, nonatomic) IBOutlet UIView *movingView;

@property (weak, nonatomic) IBOutlet UIButton *section1;
@property (weak, nonatomic) IBOutlet UIButton *section2;
@property (weak, nonatomic) IBOutlet UIButton *section3;
@property (weak, nonatomic) IBOutlet UIButton *section4;

@property (weak, nonatomic) IBOutlet UITableView *songsTableView;
@property (strong, nonatomic) NSMutableArray *songsList;
@property (strong, nonatomic) NSMutableDictionary *albumsList;
@property (strong, nonatomic) NSMutableDictionary *albumsContent;
@property (strong, nonatomic) NSMutableArray *albumTitles;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
