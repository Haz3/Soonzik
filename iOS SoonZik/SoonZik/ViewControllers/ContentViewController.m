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
#import "AddPlaylistAlertView.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.playlistsCollectionView.delegate = self;
    self.playlistsCollectionView.dataSource = self;
    
    self.playlistsCollectionView.backgroundColor = [UIColor whiteColor];
    
    UIImage *addImage = [Tools imageWithImage:[SVGKImage imageNamed:@"add_playlist"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAPlaylist) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self getAllPlaylists];
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
    AddPlaylistAlertView *popUp = [[AddPlaylistAlertView alloc] initWithTitle:@"Créer une playlist" message:@"Saisissez un titre" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Enregistrer", nil];
    [popUp setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [popUp show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"cancel");
            break;
        case 1:
            NSLog(@"enregistrer");
            [self createAPlaylist:[alertView textFieldAtIndex:0].text];
            break;
        default:
            break;
    }
}

- (void)createAPlaylist:(NSString *)title
{
    Playlist *playlist = [[Playlist alloc] init];
    playlist.title = title;
    [self.listOfPlaylists addObject:playlist];
    
    [self.playlistsCollectionView reloadData];
}

@end
