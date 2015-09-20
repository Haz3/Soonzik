//
//  PlayerViewController.m
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "CurrentListViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player.finishDelegate = self;
    
    if (self.player.listeningList.count == 0)
    {
        [self.player prepareSong:0];
        [self.navigationController popViewControllerAnimated:false];
    } else {
        self.view.backgroundColor = DARK_GREY;
        
        self.navigationItem.hidesBackButton = YES;
        UIImage *closeImage = [Tools imageWithImage:[SVGKImage imageNamed:@"close"].UIImage scaledToSize:CGSizeMake(30, 30)];
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(closePlayerViewController)];
        [closeButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = closeButton;
        
        UIImage *currentListenImage = [Tools imageWithImage:[SVGKImage imageNamed:@"current_listen"].UIImage scaledToSize:CGSizeMake(30, 30)];
        UIBarButtonItem *listenButton = [[UIBarButtonItem alloc] initWithImage:currentListenImage style:UIBarButtonItemStylePlain target:self action:@selector(displayCurrentListen)];
        [listenButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = listenButton;
        
        [self.progressionSlider setThumbImage:[Tools imageWithImage:[SVGKImage imageNamed:@"dot"].UIImage scaledToSize:CGSizeMake(14, 14)] forState:UIControlStateNormal];
        [self.shareButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"share_white"].UIImage scaledToSize:CGSizeMake(24, 24)] forState:UIControlStateNormal];
        
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.backBarButtonItem.title = @"";
        
        [self refresh];
        
        self.lastVolumeLevel = self.player.audioPlayer.volume;
        
        
        [self initPlayer];
        
        self.songTitle.font = SOONZIK_FONT_BODY_BIG;
        self.songArtist.font = SOONZIK_FONT_BODY_MEDIUM;
        
        self.currentTimeLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
        self.finishTimeLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
        
        [self.previousButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_previous"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        [self.nextButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_next"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        [self.playButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_play-circle"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        
        [self.progressionSlider setMinimumTrackTintColor:BLUE_1];
    }
    
}

- (void)displayCurrentListen {
    self.currentListViewController = [[CurrentListViewController alloc] initWithNibName:@"CurrentListViewController" bundle:nil];
    [self.navigationController pushViewController:self.currentListViewController animated:YES];
}

- (void) initPlayer
{
    self.indexOfPage = self.player.index;

    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    float imageWith = 320.0f;
    float imageEcart = 0;
    
    self.scrollView.clipsToBounds = NO;
    
    CGFloat contentOffset = 0.0f;
    
    for (int i = 0; i < self.player.listeningList.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWith + imageEcart * (i * 2 + 1), self.scrollView.frame.origin.y, imageWith, imageWith)];
        Music *music = [self.player.listeningList objectAtIndex:i];
        imgV.image = [UIImage imageNamed:music.albumImage];
        [self.scrollView addSubview:imgV];
        contentOffset += self.scrollView.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(contentOffset, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake((contentOffset / self.player.listeningList.count) * self.indexOfPage, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    [self.player stopSound];
    
    self.player.index = self.indexOfPage;
    Music *music = [self.player.listeningList objectAtIndex:self.indexOfPage];
    [self.player prepareSong:music.identifier];
    [self.player playSound];
}

- (void)closePlayerViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)refresh
{
    if (self.player.listeningList.count > 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshDisplay) userInfo:nil repeats:YES];
        
        [self.progressionSlider setMinimumValue:0.0];
        [self.progressionSlider setMaximumValue:self.player.audioPlayer.duration];
    } else {
        [self.progressionSlider setValue:0.0];
        [self.progressionSlider setMaximumValue:self.player.audioPlayer.duration];
        int duration = 0;
        self.finishTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", duration/60, duration%60];
        
        int current = 0;
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", current/60, current%60];
    }
}

- (void)refreshDisplay
{
    if (self.player.listeningList.count > 0) {
        if (!self.player.currentlyPlaying) {
            [self.playButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_play-circle"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        } else {
            [self.playButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_pause-circle"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        }
        
        Music *s = [self.player.listeningList objectAtIndex:self.player.index];
        
        [self.progressionSlider setMaximumValue:self.player.audioPlayer.duration];
        
        int duration = s.duration;
        self.finishTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", duration/60, duration%60];
        
        int current = self.player.audioPlayer.currentTime;
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", current/60, current%60];
        
        [self.progressionSlider setValue:current];
        
        self.songTitle.text = s.title;
        self.songArtist.text = s.artist.username;
    }
}

- (IBAction)goToThisPeriod:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    if (slider.value >= self.player.audioPlayer.duration) {
        [self.player pauseSound];
        [self next:nil];
    } else {
       [self.player playSoundAtPeriod:slider.value]; 
    }
}

- (IBAction)changeVolume:(id)sender
{
    UISlider *slider = sender;
    self.player.audioPlayer.volume = slider.value;
    self.lastVolumeLevel = slider.value;
}

- (IBAction)play:(id)sender
{
    [self.player playSound];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
}

- (IBAction)previous:(id)sender
{
    [self.player previous];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
    
    self.indexOfPage = self.player.index;
    [self.scrollView setContentOffset:CGPointMake(self.indexOfPage*self.scrollView.frame.size.width, 0) animated:YES];
}

- (IBAction)next:(id)sender
{
    [self.player next];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
    
    self.indexOfPage = self.player.index;
    [self.scrollView setContentOffset:CGPointMake(self.indexOfPage*self.scrollView.frame.size.width, 0) animated:YES];
}

- (void)playerHasFinishedToPlay
{
    [self next:nil];
    [self play:nil];
}

- (IBAction)random:(id)sender
{
    
}

- (IBAction)repeat:(id)sender
{
    switch (self.player.repeatingLevel) {
        case 0:
            // repeat the list when it's finished
            NSLog(@"Repeating all");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-1_icon.png"] forState:UIControlStateNormal];
            break;
        case 1:
            // just repeat this one indefinely only
            NSLog(@"Repeating one");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-2_icon.png"] forState:UIControlStateNormal];
            break;
        case 2:
            // stop the repeating action
            NSLog(@"NO Repeating");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-0_icon.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [self.player repeat];
}

@end
