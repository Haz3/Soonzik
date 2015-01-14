//
//  ContentViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ContentViewController.h"
#import "PlaylistViewController.h"
#import "AlbumViewController.h"
#import "TitlePlaylistCollectionViewCell.h"
#import "TitleAlbumsTableViewCell.h"
#import "Playlist.h"
#import "Album.h"
#import "Tools.h"
#import "SVGKImage.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.playlistsCollectionView.delegate = self;
    self.playlistsCollectionView.dataSource = self;
    
    self.playlistsCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.albumsTableView.delegate = self;
    self.albumsTableView.dataSource = self;
    
    CGSize size = CGSizeMake(self.horizontalContentView.frame.size.width, self.horizontalContentView.frame.size.height + self.playerPreviewView.frame.size.height);
    self.horizontalScrollView.contentSize = size;
    [self.horizontalScrollView addSubview:self.horizontalContentView];
    
    [self.playlistButton addTarget:self action:@selector(displayPlaylists) forControlEvents:UIControlEventTouchUpInside];
    [self.playlistButton setTitleColor:BLUE_2 forState:UIControlStateNormal];
    [self.albumsButton addTarget:self action:@selector(displayAlbums) forControlEvents:UIControlEventTouchUpInside];
    [self.albumsButton setTitleColor:BLUE_2 forState:UIControlStateNormal];
    self.movableView.backgroundColor = BLUE_2;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    UIImage *addImage = [Tools imageWithImage:[SVGKImage imageNamed:@"add_playlist"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAPlaylist) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self getAllPlaylists];
    [self getAllALbums];
    
    self.index = 0;
    
    self.addPlaylistVC = [[AddPlaylistViewController alloc] initWithNibName:@"AddPlaylistViewController" bundle:nil];
}

- (void)getAllPlaylists
{
    self.listOfPlaylists = [[NSMutableArray alloc] init];
    
    Music *s1 = [[Music alloc] init];
    s1.title = @"song1";
    s1.artist = [[User alloc] init];
    s1.artist.username = @"John Newman";
    s1.image = @"song1.jpg";
    s1.file = @"song1";
    
    Music *s2 = [[Music alloc] init];
    s2.title = @"song2";
    s2.artist = [[User alloc] init];
    s2.artist.username = @"Route 94";
    s2.image = @"song2.jpg";
    s2.file = @"song2";
    
    Music *s3 = [[Music alloc] init];
    s3.title = @"song3";
    s3.artist = [[User alloc] init];
    s3.artist.username = @"Duke Dumont";
    s3.image = @"song3.jpg";
    s3.file = @"song3";
    
    Music *s4 = [[Music alloc] init];
    s4.title = @"song4";
    s4.artist = [[User alloc] init];
    s4.artist.username = @"Stromae";
    s4.image = @"song4.jpg";
    s4.file = @"song4";
    
    NSMutableArray *musics = [[NSMutableArray alloc] initWithObjects:s2, s3, nil];
    Playlist *playlist = [[Playlist alloc] init];
    playlist.title = @"PlayList Cool 1";
    playlist.identifier = 1;
    playlist.listOfMusics = musics;
    [self.listOfPlaylists addObject:playlist];
    
    musics = [[NSMutableArray alloc] initWithObjects:s1, s2, s3, s4, nil];
    playlist = [[Playlist alloc] init];
    playlist.title = @"PlayList Cool 2";
    playlist.identifier = 2;
    playlist.listOfMusics = musics;
    [self.listOfPlaylists addObject:playlist];
    
    musics = [[NSMutableArray alloc] initWithObjects:s2, s3, nil];
    playlist = [[Playlist alloc] init];
    playlist.title = @"PlayList Cool 3";
    playlist.identifier = 3;
    playlist.listOfMusics = musics;
    [self.listOfPlaylists addObject:playlist];
}

- (void) getAllALbums
{
    self.listOfAlbums = [[[Factory alloc] provideListWithClassName:@"Album"] mutableCopy];
}

- (void) displayPlaylists
{
    NSLog(@"display playlist");
    UIImage *addImage = [Tools imageWithImage:[SVGKImage imageNamed:@"add_playlist"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAPlaylist) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightButton;

    
    self.index = 0;
    [self.horizontalScrollView setContentOffset:CGPointMake(self.index * self.view.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [self.movableView setFrame:CGRectMake(0, self.movableView.frame.origin.y, self.movableView.frame.size.width, self.movableView.frame.size.height)];
    }];
    
    //[self.playlistsCollectionView reloadData];
}

- (void) displayAlbums
{
    self.navigationItem.rightBarButtonItems = nil;

    self.index = 1;
    [self.horizontalScrollView setContentOffset:CGPointMake(self.index * self.view.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [self.movableView setFrame:CGRectMake(self.view.frame.size.width/2, self.movableView.frame.origin.y, self.movableView.frame.size.width, self.movableView.frame.size.height)];
    }];
    //[self.albumsTableView reloadData];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfAlbums.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 60;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    TitleAlbumsTableViewCell *cell = (TitleAlbumsTableViewCell *)[self.albumsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [self.albumsTableView registerNib:[UINib nibWithNibName:@"TitleAlbumsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [self.albumsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Album *album = [self.listOfAlbums objectAtIndex:indexPath.row];
    cell.albumTitle.text = album.title;
    cell.albumArtist.text = album.artist.username;
    cell.albumImage.image = [UIImage imageNamed:album.image];
     
     UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
     lineView.backgroundColor = BACKGROUND_COLOR;
     [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"album table view");
    AlbumViewController *albumVC = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    Album *album = [self.listOfAlbums objectAtIndex:indexPath.row];
    albumVC.album = album;
    [self.navigationController pushViewController:albumVC animated:YES];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listOfPlaylists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    [collectionView registerNib:[UINib nibWithNibName:@"TitlePlaylistCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    TitlePlaylistCollectionViewCell *cell = (TitlePlaylistCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    [cell initCell];
    
    Playlist *playlist = [self.listOfPlaylists objectAtIndex:indexPath.row];
    cell.playlistTitle.text = playlist.title;
    cell.nbrOfTracks.text = [NSString stringWithFormat:@"%i titres", playlist.listOfMusics.count];
    cell = [self loadImagePreviewPlaylist:playlist.listOfMusics forCell:cell];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"element: %i", indexPath.row);
    Playlist *playlist = [self.listOfPlaylists objectAtIndex:indexPath.row];
    
    PlaylistViewController *vc = [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
    vc.playlist = playlist;
    [self.navigationController pushViewController:vc animated:YES];
}

- (TitlePlaylistCollectionViewCell *)loadImagePreviewPlaylist:(NSArray *)playlist forCell:(TitlePlaylistCollectionViewCell *)cell
{
    int i = 1;
    for (Music *music in playlist) {
        switch (i) {
            case 1:
                cell.album1Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            case 2:
                cell.album2Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            case 3:
                cell.album3Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            case 4:
                cell.album4Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)addAPlaylist
{
    if (popoverController == nil)
    {
        self.addPlaylistVC.closePopupDelegate = self;
        if ([self.addPlaylistVC respondsToSelector:@selector(setPreferredContentSize:)]) {
            self.addPlaylistVC.preferredContentSize = CGSizeMake(274, 126);
        }
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:self.addPlaylistVC];
        contentViewController.navigationBar.hidden = YES;
        
        popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        popoverController.delegate = self;
        [popoverController presentPopoverFromRect:CGRectMake(self.view.frame.size.width - 30, self.navigationController.navigationBar.frame.size.height, 30, 30) inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}

@end
