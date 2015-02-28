//
//  AlbumViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AlbumViewController.h"
#import "HeaderAlbumTableView.h"
#import "AppDelegate.h"
#import "SVGKImage.h"
#import "AlbumTableViewCell.h"
#import "MusicOptionsButton.h"
#import "ArtistViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

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
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.album = [[Factory alloc] provideObjectWithClassName:@"Album" andIdentifier:self.album.identifier];
    
    self.listOfMusics = self.album.listOfMusics;
    
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfMusics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderAlbumTableView *view = (HeaderAlbumTableView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderAlbumTableView" owner:self options:nil] firstObject];
    view.albumImage.image = [UIImage imageNamed:self.album.image];
    view.albumTitle.text = self.album.title;
    view.backgroundColor = BACKGROUND_COLOR;
    [view initHeader];
    [view.playAllButton addTarget:self action:@selector(playAlbum) forControlEvents:UIControlEventTouchUpInside];
    return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AlbumTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    
    Music *music = [self.listOfMusics objectAtIndex:indexPath.row];
    NSLog(@"music.file : %@", music.file);
    
    [cell initCell];
    
    cell.musicTitle.text = music.title;
    cell.musicLength.text = [NSString stringWithFormat:@"%.2i:%.2i", music.duration/60, music.duration%60];
    [cell.optionsButton addTarget:self action:@selector(displayPopUp:) forControlEvents:UIControlEventTouchUpInside];
    cell.optionsButton.music = music;
    //cell.optionsButton.playlist; A FAIRE DISPARAITRE
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Music *s = [self.listOfMusics objectAtIndex:indexPath.row];
    NSLog(@"song: %@", s.title);
    NSLog(@"song.file : %@", s.file);
    
    NSString *file = [s.file stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
    
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    if ([self.player currentlyPlaying])
        [self.player pauseSound];
    self.player.listeningList = nil;
    self.player.listeningList = [[NSMutableArray alloc] init];
    [self.player.listeningList addObject:s];
    self.player.index = 0;
    [self.player prepareSong:file];
    [self.player playSound];
    self.player.songName = s.title;
}

- (void)playAlbum
{
    NSLog(@"clic");
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player.listeningList = [[NSMutableArray alloc] init];
    [self.player.audioPlayer stop];
    self.player.index = 0;
    self.player.oldIndex = 0;
    
    for (Music *music in self.album.listOfMusics) {
        [self.player.listeningList addObject:music];
        NSLog(@"add music to listening list");
    }
    
    [self.player playSound];
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
    
    UIAlertView *popUp = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Vous avez ajouté: %@ à la liste de lecture actuelle", music.title] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    
    [popUp show];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closePopUp) userInfo:nil repeats:NO];
    
    NSLog(@"Vous avez cliqué sur la piste : %@", music.title);
}

- (void)addBlurEffectOnView:(UIView *)view
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = view.bounds;
    visualEffectView.tag = 200;
    [view addSubview:visualEffectView];
    visualEffectView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        visualEffectView.alpha = 1;
    }];
}

- (void)removeBlurEffect:(int)tag onView:(UIView *)v
{
    for (UIView *view in v.subviews) {
        if (view.tag == tag) {
            [UIView animateWithDuration:0.5 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

@end
