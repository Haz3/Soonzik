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
#import "LongPressGestureRecognizer.h"
#import "AlbumViewController.h"
#import "PlayListsHeaderView.h"

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
    
    [self getAllPlaylists];
    
   [self.playlistTableView setFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - self.navigationController.navigationBar.frame.size.height-self.statusBarHeight-self.actionsOnPlaylistView.frame.size.height*2 - self.playerPreviewView.frame.size.height)];
    
    NSLog(@"height of table view : %f", self.screenHeight - self.navigationController.navigationBar.frame.size.height-self.statusBarHeight-self.actionsOnPlaylistView.frame.size.height*2 - self.playerPreviewView.frame.size.height);
    
    self.myPlaylistsLabel.textColor = [UIColor whiteColor];
    self.myPlaylistsLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    
    self.playlistTableView.dataSource = self;
    self.playlistTableView.delegate = self;
}

- (void)getAllPlaylists
{
    self.playlists = [[NSMutableDictionary alloc] init];
    
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
    
    self.tracks = [[NSMutableArray alloc] initWithObjects:s2, s3, nil];
    [self.playlists setValue:self.tracks forKey:@"PlayList Cool"];
    
    self.tracks = [[NSMutableArray alloc] initWithObjects:s1, s2, s3, s4, nil];
    [self.playlists setValue:self.tracks forKey:@"PlayList de fou"];
    
    self.tracks = [[NSMutableArray alloc] initWithObjects:s2, s3, nil];
    [self.playlists setValue:self.tracks forKey:@"PlayList Cool 2"];
    
    [self getPlayListTitles];
}

- (void)goToAlbumView:(Music *)music
{
    [self closePopUp];
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
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

- (void)getPlayListTitles
{
    self.playlistTitles = [[NSMutableArray alloc] init];
    
    for (NSString *playlist in self.playlists)
        [self.playlistTitles addObject:playlist];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *nameOfThePlaylist = [self.playlistTitles objectAtIndex:section];
    NSArray *playlistContents = [[NSArray alloc] initWithArray:[self.playlists objectForKey:nameOfThePlaylist]];
    
    return playlistContents.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.playlists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PlayListsHeaderView *headerView = (PlayListsHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"PlayListsHeaderView" owner:self options:nil] firstObject];
    
    NSString *nameOfThePlaylist = [self.playlistTitles objectAtIndex:section];
    headerView.playlistLabel.text = nameOfThePlaylist;
    NSArray *playlistContents = [[NSArray alloc] initWithArray:[self.playlists objectForKey:nameOfThePlaylist]];
    headerView.nbrOfTracks.text = [NSString stringWithFormat:@"%i titres", playlistContents.count];
    headerView = [self loadImagePreviewPlaylist:playlistContents andHeader:headerView];
    
    return headerView;
}

- (PlayListsHeaderView *)loadImagePreviewPlaylist:(NSArray *)playlist andHeader:(PlayListsHeaderView *)headerView
{
    int i = 1;
    for (Music *music in playlist) {
        switch (i) {
            case 1:
                headerView.album1Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            case 2:
                headerView.album2Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            case 3:
                headerView.album3Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            case 4:
                headerView.album4Image.image = [UIImage imageNamed:music.image];
                i++;
                break;
            default:
                break;
        }
    }
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
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
    NSString *nameOfThePlaylist = [self.playlistTitles objectAtIndex:indexPath.section];
    NSMutableArray *playlist = [self.playlists objectForKey:nameOfThePlaylist];
    Music *s = [playlist objectAtIndex:indexPath.row];
    
    cell.trackTitle.text = s.title;
    cell.trackImage.image = [UIImage imageNamed:s.image];
    /*
    UIButton *albumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [albumButton setImage:[UIImage imageNamed:s.image] forState:UIControlStateNormal];
    [albumButton addTarget:self action:@selector(goToArtistView) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:albumButton];*/
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    LongPressGestureRecognizer *lpgr = [[LongPressGestureRecognizer alloc] initWithTarget:self action:@selector(displayPopUp:)];
    lpgr.minimumPressDuration = 1;
    lpgr.delegate = self;
    lpgr.song = s;
    //lpgr.playlist =
    
    [cell addGestureRecognizer:lpgr];
    
    // Add utility buttons
  /*  NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"add-to-playlist_icon.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"empty_list.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@""]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"twitter.png"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;*/
    
    return cell;
}
/*
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ajout a la liste courante" message:@"La musique a été ajouté à la liste de lecture courante" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            AddToCurrentListeningButton *btn = [[AddToCurrentListeningButton alloc] init];
            btn.song = cell
            self addToCurrentListening:(AddToCurrentListeningButton *)
            [alertView show];
            break;
        }
        case 1:
        {
            AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Sharing" message:@"Just shared the pattern image on Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            break;
        }
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Sharing" message:@"Just shared the pattern image on Twitter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // More button is pressed
            UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", nil];
            [shareActionSheet showInView:self.view];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button is pressed
            NSIndexPath *cellIndexPath = [self.playlistTableView indexPathForCell:cell];
            //[patterns removeObjectAtIndex:cellIndexPath.row];
            //[patternImages removeObjectAtIndex:cellIndexPath.row];
            [self.playlistTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}*/

- (void)displayPopUp:(LongPressGestureRecognizer *)lp
{
    if (lp.state == UIGestureRecognizerStateBegan) {
        [self addBlurEffectOnView:self.view];
        NSLog(@"element: %@", lp.song);
        OnLTMusicPopupView *popUpView = (OnLTMusicPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"OnLTMusicPopupView" owner:self options:nil] objectAtIndex:0];
        popUpView.tag = 100;
        popUpView.choiceDelegate = self;
        [self.view addSubview:popUpView];
        [popUpView initPopupWithSong:lp.song andPlaylist:lp.playlist];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nameOfThePlaylist = [self.playlistTitles objectAtIndex:indexPath.section];
    NSMutableArray *playlist = [self.playlists objectForKey:nameOfThePlaylist];
    Music *s = [playlist objectAtIndex:indexPath.row];
    NSLog(@"song: %@", s.title);
    
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
