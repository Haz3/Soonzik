//
//  PlaylistViewController.m
//  SoonZik
//
//  Created by LLC on 24/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlayListsCells.h"
#import "AddToCurrentListeningButton.h"
#import "AppDelegate.h"
#import "Music.h"
#import "ArtistViewController.h"
#import "MusicOptionsButton.h"
#import "AlbumViewController.h"
#import "SVGKImage.h"
#import "Tools.h"

@interface PlaylistViewController ()

@end


@implementation PlaylistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self getAllPlaylists];
    
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    /*[self.playlistTableView setFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - self.navigationController.navigationBar.frame.size.height-self.statusBarHeight-self.actionsOnPlaylistView.frame.size.height*2 - self.playerPreviewView.frame.size.height)];*/
    
    self.playlistTableView.dataSource = self;
    self.playlistTableView.delegate = self;
}

- (void)closePopup:(NSString *)country
{
   /* [self.prefixButton setTitle:[NSString stringWithFormat:@"+%@", country] forState:UIControlStateNormal];
    self.client.telIndicatif = country;
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
    */
}

- (void)goToAlbumView:(Music *)music
{
    [self closePopUp];
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = [[Album alloc] init];
    vc.album.identifier = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToArtistView:(Music *)music
{
    [self closePopUp];
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addToCurrentPlaylist:(Music *)music
{
    [self closePopUp];
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    [self.player.listeningList addObject:music];
    
    self.popUp = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Vous avez ajouté: %@ à la liste de lecture actuelle", music.title] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    
    [self.popUp show];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closePopUp) userInfo:nil repeats:NO];
    
    NSLog(@"Vous avez cliqué sur la piste : %@", music.title);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlist.listOfMusics.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor grayColor];
    UIButton *playAllButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 312, 36)];
    [playAllButton setTitle:@"Lire" forState:UIControlStateNormal];
    [playAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playAllButton addTarget:self action:@selector(playAllPlaylist) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:playAllButton];
    
    return view;
    
}

- (void) playAllPlaylist
{
    NSLog(@"clic");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    PlayListsCells *cell = (PlayListsCells *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PlayListsCells" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    [cell initCell];
    
    //get the song name
    
    Music *s = [self.playlist.listOfMusics objectAtIndex:indexPath.row];
    cell.trackTitle.text = s.title;
    cell.trackArtist.text = s.artist.username;
    [cell.optionsButton addTarget:self action:@selector(displayPopUp:) forControlEvents:UIControlEventTouchUpInside];
    cell.optionsButton.music = s;
    cell.optionsButton.playlist = self.playlist;
    
    UIImage* optionImage = [Tools imageWithImage:[SVGKImage imageNamed:@"music_options.svg"].UIImage scaledToSize:CGSizeMake(30, 30)];
    [cell.optionsButton setImage:optionImage forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)displayPopUp:(MusicOptionsButton *)btn
{
    [self addBlurEffectOnView:self.view];
    OnLTMusicPopupView *popUpView = (OnLTMusicPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"OnLTMusicPopupView" owner:self options:nil] objectAtIndex:0];
    popUpView.tag = 100;
    popUpView.choiceDelegate = self;
    [self.view addSubview:popUpView];
    [popUpView initPopupWithSong:btn.music andPlaylist:btn.playlist];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{/*
    NSString *nameOfThePlaylist = [self.playlistTitles objectAtIndex:indexPath.section];
    NSMutableArray *playlist = [self.playlists objectForKey:nameOfThePlaylist];
    Music *s = [playlist objectAtIndex:indexPath.row];
    
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    if ([self.player currentlyPlaying])
        [self.player pauseSound];
    self.player.listeningList = nil;
    self.player.listeningList = [[NSMutableArray alloc] init];
    [self.player.listeningList addObject:s];
    self.player.index = 0;
    [self.player prepareSong:s.file];
    [self.player playSound];
    self.player.songName = s.title;
*/
  }

- (void)closePopUp
{
    for (UIView *v in [self.view subviews]) {
        if (v.tag == 100) {
            [UIView animateWithDuration:1 animations:^{
                v.alpha = 0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
    [self removeBlurEffect:200 onView:self.view];
}

- (void)closePopUpView
{
    for (UIView *v in [self.view subviews]) {
        if (v.tag == 100) {
            [UIView animateWithDuration:1 animations:^{
                v.alpha = 0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
    [self removeBlurEffect:200 onView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
