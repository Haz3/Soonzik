//
//  TypeViewController.m
//  SoonZik
//
//  Created by devmac on 27/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "HomeViewController.h"
#import "PlayerViewController.h"
#import "BattleViewController.h"
#import "ContentViewController.h"
#import "GeolocationViewController.h"
#import "PackViewController.h"
#import "ArtistViewController.h"
#import "ExploreViewController.h"
#import "FriendsViewController.h"
#import "ErrorLoadingView.h"
#import "LeftMenuViewController.h"
#import "AppDelegate.h"
#import "Music.h"
#import "Tools.h"
#import "SVGKImage.h"

@interface TypeViewController ()

@end

@implementation TypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.menuView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *menuImage = [Tools imageWithImage:[SVGKImage imageNamed:@"menu"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIImage *searchImage = [Tools imageWithImage:[SVGKImage imageNamed:@"search"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    [self initTitleView];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.menuOpened = NO;
    self.searchOpened = NO;

    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player.finishDelegate = self;
    
    [self refreshThePlayerPreview];
}

- (void)playerHasFinishedToPlay
{
    NSLog(@"fini");
}

- (void)initTitleView
{
    TitleSongPreview *songPreview = [[[NSBundle mainBundle] loadNibNamed:@"TitleSongPreview" owner:self options:nil] firstObject];
    self.navigationItem.titleView = songPreview;
    
    UITapGestureRecognizer *tapOnListeningPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchPlayerView:)];
    [self.navigationItem.titleView addGestureRecognizer:tapOnListeningPreview];
}

- (void)refreshThePlayerPreview
{
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(refreshPreview) userInfo:nil repeats:YES];
}

- (void)refreshPreview
{
    TitleSongPreview *songPreview = (TitleSongPreview *)self.navigationItem.titleView;
    if (self.player.listeningList.count > 0) {
    
        Music *s = [self.player.listeningList objectAtIndex:self.player.index];
        
        if (self.player.audioPlayer != nil) {
            
        } else {
            [self.player prepareSong:s.file];
        }
        
        songPreview.albumImage.image = [UIImage imageNamed:s.image];
        songPreview.trackLabel.text = s.title;
        songPreview.artistLabel.text = s.artist.username;
        
    } else {
        songPreview.albumImage.image = nil;
        songPreview.trackLabel.text = nil;
        songPreview.artistLabel.text = nil;
    }
}

- (void)launchPlayerView:(UITapGestureRecognizer *)reco
{
    [reco locationInView:[reco.view superview]];
    
    if (self.player.listeningList.count > 0) {
        PlayerViewController *vc = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:@"openPlayer"];
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"La liste de lecture est vide" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

- (void)closeTheSession
{
    self.prefs = [NSUserDefaults standardUserDefaults];
    [self.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:nil] forKey:@"User"];
    [self.prefs synchronize];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    ConnexionViewController *vc = [[ConnexionViewController alloc] initWithNibName:@"ConnexionViewController" bundle:nil];
    
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    (void)[self.navigationController initWithRootViewController:vc];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void)play
{
    NSLog(@"play");
    
    if (self.player.listeningList.count > 0) {
        
        Music *s = [self.player.listeningList objectAtIndex:self.player.index];
        
        if (!self.player.currentlyPlaying) {
            [self.player playSound];
            self.player.songName = s.title;
        } else {
            [self.player pauseSound];
        }
    }
}

- (void)previous
{
    NSLog(@"previous");
    NSLog(@"%i", self.player.index);
    if (self.player.listeningList.count > 0) {
        if (self.player.index > 0) {
            self.player.index--;
            Music *s = [self.player.listeningList objectAtIndex:self.player.index];
            [self.player prepareSong:s.file];
            if (self.player.currentlyPlaying) {
                [self.player playSound];
                self.player.songName = s.title;
            }
        }
    }
}

- (void)next
{
    NSLog(@"next");
    
    if (self.player.listeningList.count > 0) {
        if (self.player.repeatingLevel == 2) {
            Music *s = [self.player.listeningList objectAtIndex:self.player.index];
            [self.player prepareSong:s.file];
            [self.player playSound];
            self.player.songName = s.title;
        } else if (self.player.repeatingLevel == 1) {
            if (self.player.index == self.player.listeningList.count - 1) {
                self.player.index = 0;
            } else {
                self.player.index++;
            }
            Music *s = [self.player.listeningList objectAtIndex:self.player.index];
            [self.player prepareSong:s.file];
            [self.player playSound];
            self.player.songName = s.title;
        } else if (self.player.repeatingLevel == 0) {
            if (self.player.index < self.player.listeningList.count - 1) {
                self.player.index++;
                Music *s = [self.player.listeningList objectAtIndex:self.player.index];
                [self.player prepareSong:s.file];
                if (self.player.currentlyPlaying) {
                    [self.player playSound];
                    self.player.songName = s.title;
                }
            }
        }
    }
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

- (void)addBlurDarkEffectOnView:(UIView *)view
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)showErrorDuringLoading
{
    ErrorLoadingView *errorView = [[[NSBundle mainBundle] loadNibNamed:@"ErrorLoadingView" owner:self options:nil] firstObject];
    errorView.tag = 404;
    
    [self.view addSubview:errorView];
}

- (void)hideErrorDuringLoading
{
    for (UIView *view in self.view.subviews) {
        if (view.tag == 404) {
            [view removeFromSuperview];
        }
    }
}


@end
