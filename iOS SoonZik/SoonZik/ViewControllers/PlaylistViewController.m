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
#import "AllTheIncludes.h"
#import "AppDelegate.h"
#import "Song.h"
#import "ArtistViewController.h"
#import "LongPressGestureRecognizer.h"

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
    
    [self.playlistTableView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+self.statusBarHeight+self.actionsOnPlaylistView.frame.size.height*2, self.screenWidth, self.screenHeight - self.navigationController.navigationBar.frame.size.height-self.statusBarHeight-self.actionsOnPlaylistView.frame.size.height*2 - self.playerPreviewView.frame.size.height)];
    
    NSLog(@"height of table view : %f", self.screenHeight - self.navigationController.navigationBar.frame.size.height-self.statusBarHeight-self.actionsOnPlaylistView.frame.size.height*2 - self.playerPreviewView.frame.size.height);
    
    self.myPlaylistsLabel.textColor = [UIColor whiteColor];
    self.myPlaylistsLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    
    self.playlistTableView.dataSource = self;
    self.playlistTableView.delegate = self;
    
}

- (void)getAllPlaylists
{
    self.playlists = [[NSMutableDictionary alloc] init];
    
    Song *s1 = [[Song alloc] init];
    s1.title = @"song1";
    s1.artist = @"John Newman";
    s1.image = @"song1.jpg";
    s1.file = @"song1";
    
    Song *s2 = [[Song alloc] init];
    s2.title = @"song2";
    s2.artist = @"Route 94";
    s2.image = @"song2.jpg";
    s2.file = @"song2";
    
    Song *s3 = [[Song alloc] init];
    s3.title = @"song3";
    s3.artist = @"Duke Dumont";
    s3.image = @"song3.jpg";
    s3.file = @"song3";
    
    Song *s4 = [[Song alloc] init];
    s4.title = @"song4";
    s4.artist = @"Stromae";
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
    NSString *nameOfThePlaylist = [self.playlistTitles objectAtIndex:section];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, sectionView.frame.size.width, sectionView.frame.size.height-4)];
    label.font = SOONZIK_FONT_BODY_SMALL;
    label.textColor = [UIColor whiteColor];
    label.text = nameOfThePlaylist;
    
    [sectionView addSubview:label];
    
    
    UIButton *playPlaylistButton = [[UIButton alloc] initWithFrame:CGRectMake(sectionView.frame.size.width - 25, 3, 15, 15)];
    [playPlaylistButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
    [playPlaylistButton addTarget:self action:@selector(launchPlaylist) forControlEvents:UIControlEventTouchUpInside];
    
    [sectionView addSubview:playPlaylistButton];
    
    [sectionView setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    
    return sectionView;
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
    Song *s = [playlist objectAtIndex:indexPath.row];
    
    cell.trackTitle.text = s.title;
    
    UIButton *albumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [albumButton setImage:[UIImage imageNamed:s.image] forState:UIControlStateNormal];
    [albumButton addTarget:self action:@selector(goToArtistView) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:albumButton];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    LongPressGestureRecognizer *lpgr = [[LongPressGestureRecognizer alloc] initWithTarget:self action:@selector(displayPopUp:)];
    lpgr.minimumPressDuration = 1;
    lpgr.delegate = self;
    lpgr.song = s;
    
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

- (void)displayPopUp:(LongPressGestureRecognizer *)lp
{
    if (lp.state == UIGestureRecognizerStateBegan) {
        NSLog(@"element: %@", lp.song);
        OnLTMusicPopupView *popUpView = (OnLTMusicPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"OnLTMusicPopupView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:popUpView];
        [popUpView initPopupWithSong:lp.song];
    }
    
}

- (void)launchPlaylist
{
    
}

- (void)goToArtistView
{
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nameOfThePlaylist = [self.playlistTitles objectAtIndex:indexPath.section];
    NSMutableArray *playlist = [self.playlists objectForKey:nameOfThePlaylist];
    Song *s = [playlist objectAtIndex:indexPath.row];
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

- (void)addToCurrentListening:(AddToCurrentListeningButton *)btn
{
    Song *s = btn.song;
    
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    [self.player.listeningList addObject:s];
    
    self.popUp = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Vous avez ajouté: %@ à la liste de lecture actuelle", s.title] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    
    [self.popUp show];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closePopUp) userInfo:nil repeats:NO];
    
    NSLog(@"Vous avez cliqué sur la piste : %@", s.title);
    
}

- (void)closePopUp
{
    [UIAlertView animateWithDuration:2 animations:^{
        [self.popUp dismissWithClickedButtonIndex:0 animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
