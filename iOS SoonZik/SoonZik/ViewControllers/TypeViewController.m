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
#import "PlaylistViewController.h"
#import "GeolocationViewController.h"
#import "WeekPackViewController.h"
#import "ArtistViewController.h"
#import "ExploreViewController.h"
#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "Song.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self titleImage];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.screenHeight = screenSize.size.height;
    self.screenWidth = screenSize.size.width;
    
    [self loadBackgroundImage];
    
    self.statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem.title = @"";
    self.menuOpened = NO;
    self.searchOpened = NO;

    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player.finishDelegate = self;
    
    [self createMenuData];
    
    [self deselectAllRows];
    
    [self initPlayerPreview];
    
    [self initHeader];
    [self initMenuView];
    
    UITapGestureRecognizer *tapOnListeningPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchPlayerView:)];
    
    [self.playerPreviewView addGestureRecognizer:tapOnListeningPreview];

    UISwipeGestureRecognizer *openMenuView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openTheMenuView)];
    [openMenuView setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:openMenuView];
    
    UISwipeGestureRecognizer *closeMenuView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeTheMenuView)];
    [closeMenuView setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:closeMenuView];
    
    [self refreshThePlayerPreview];
}

- (void)loadBackgroundImage
{
    // detect iphone 5 screen
    if (self.screenHeight == 568 && self.screenWidth == 320)
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone5_background.jpg"]]];
    
    NSLog(@"background settings:\n height: %f\rwidth: %f", self.screenHeight, self.screenWidth);
}


- (void)titleImage
{
    UIImage *image = [UIImage imageNamed:@"logo_SZ.png"];
    UIImage *tempImage = nil;
    CGSize targetSize = CGSizeMake(100, 28);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0, 0);
    thumbnailRect.size.width = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *centerImageView = [[UIImageView alloc] initWithImage:tempImage];
    self.navigationItem.titleView = centerImageView;
}

- (void)deselectAllRows
{
    for (int i=0; i < self.tableData.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.menuTableView.delegate tableView:self.menuTableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)openTheMenuView
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.menuView setFrame:CGRectMake(0, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height)];
    } completion:nil];
    self.menuOpened = YES;
}

- (void)closeTheMenuView
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.menuView setFrame:CGRectMake(-self.menuView.frame.size.width, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height)];
    } completion:nil];
    self.menuOpened = NO;
}

- (void)closeTheMenuView2:(UITapGestureRecognizer *)reco
{
    CGPoint point = [reco locationInView:self.view];
    
    if (point.x > self.menuView.frame.origin.x + self.menuView.frame.size.width) {
        NSLog(@"Touched point is %f %f", point.x, point.y);
        [self closeTheMenuView];
    }
    
}

- (void)launchPlayerView:(UITapGestureRecognizer *)reco
{
    [reco locationInView:[reco.view superview]];
    
    if (self.player.listeningList.count > 0) {
        PlayerViewController *vc = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"La liste de lecture est vide" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

- (void)createMenuData
{
    self.tableData = [[NSMutableArray alloc] init];
    
    [self.tableData addObject:@"Vos news"];
    [self.tableData addObject:@"Explorer"];
    [self.tableData addObject:@"Packs"];
    [self.tableData addObject:@"Monde musical"];
    [self.tableData addObject:@"Battle"];
    [self.tableData addObject:@"Playlists"];
    [self.tableData addObject:@"Amis"];
    [self.tableData addObject:@"Achats"];
    [self.tableData addObject:@"Déconnexion"];
    
    self.tableImageData = [[NSMutableArray alloc] init];
    
    [self.tableImageData addObject:@"news_icon.png"];
    [self.tableImageData addObject:@"explore_icon.png"];
    [self.tableImageData addObject:@"pack_icon.png"];
    [self.tableImageData addObject:@"world_icon.png"];
    [self.tableImageData addObject:@"battle_icon.png"];
    [self.tableImageData addObject:@"playlist_icon.png"];
    [self.tableImageData addObject:@"profile_icon.png"];
    [self.tableImageData addObject:@"dollar_icon.png"];
    [self.tableImageData addObject:@""];
}

- (void)initHeader
{
    UIImage *menuImage = [self imageWithImage:[UIImage imageNamed:@"menu_icon.png"] scaledToSize:CGSizeMake(19, 19)];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(displayMenu)];
    
    UIImage *searchImage = [self imageWithImage:[UIImage imageNamed:@"search_icon.png"] scaledToSize:CGSizeMake(19, 19)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(displaySearch)];
    
    self.navigationItem.leftBarButtonItems = @[menuButton];
    self.navigationItem.rightBarButtonItems = @[searchButton];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)initMenuView
{
    CGRect appframe = [[UIScreen mainScreen] applicationFrame];
    appframe.origin.y += self.navigationController.navigationBar.frame.size.height;
    appframe.size.height -= self.navigationController.navigationBar.frame.size.height + self.playerPreviewView.frame.size.height;
    
    // initialize menu view
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(-180, appframe.origin.y, 180, appframe.size.height)];
    [self.menuView setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    [self setBlurAlpha:0.75];
    
    [self.view addSubview:self.menuView];
    
    // initialize menu userpreview
    self.menuUserPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuView.frame.size.width, 50)];
    [self.menuUserPreview setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    [self.menuView addSubview:self.menuUserPreview];
    
    // add user infos
    [self createUserPreview];
    
    // initialize menu tableview
    self.menuTableView = [[MenuTabView alloc] init];
    [self.menuTableView initTableView];
    self.menuTableView.clickDelegate = self;
    [self.menuTableView loadWithData:self.tableData and:self.tableImageData];
    [self.menuTableView setFrame:CGRectMake(0, self.menuUserPreview.frame.size.height, self.menuView.frame.size.width, self.menuView.frame.size.height-self.menuUserPreview.frame.size.height)];
    [self.menuView addSubview:self.menuTableView];
    
    // initialize search view
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(320, appframe.origin.y, 320, appframe.size.height)];
    [self.view addSubview:self.searchView];
    
    // initialize search tableview
    self.searchTableView = (SearchTabView *)[[[NSBundle mainBundle] loadNibNamed:@"SearchTabView" owner:self options:nil] objectAtIndex:0];
    [self.searchTableView initContent];

    [self.searchTableView setFrame:CGRectMake(0, 0, self.searchView.frame.size.width, self.searchView.frame.size.height)];
    [self.searchView addSubview:self.searchTableView];
    
}

- (void)setBlurAlpha:(CGFloat)alphaValue
{
    int numComponents = CGColorGetNumberOfComponents([[self.view backgroundColor] CGColor]);
    NSLog(@"number of components: %d", numComponents);
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents([[self.view backgroundColor] CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        [self.menuView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alphaValue]];
    } else {
        [self.menuView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:alphaValue]];
    }
}

- (void)initPlayerPreview
{
    self.playerPreviewView = [[PlayerPreviewView alloc] initWithFrame:CGRectMake(0, self.screenHeight-PREVIEW_HEIGHT, self.screenWidth, PREVIEW_HEIGHT)];
    [self.view addSubview:self.playerPreviewView];
    
    self.playerPreviewView.actionDelegate = self;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    self.playerPreviewView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.playerPreviewView.layer.shadowOpacity = 1;
    self.playerPreviewView.layer.shadowRadius = 10;
    self.playerPreviewView.layer.shadowOffset = CGSizeMake(0, -2);
}

- (void)createUserPreview
{
    CGFloat square = 35.0;
    CGFloat avatarHeight = (self.menuUserPreview.frame.size.height - square) / 2;
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(avatarHeight, avatarHeight, square, square)];
    [avatar setImage:[UIImage imageNamed:@"artist1.jpg"]];
    [self.menuUserPreview addSubview:avatar];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarHeight * 2 + avatar.frame.size.width, 0, self.menuUserPreview.frame.size.width - (avatarHeight * 2 + avatar.frame.size.width), self.menuUserPreview.frame.size.height)];
    [userNameLabel setTextColor:[UIColor whiteColor]];
    [userNameLabel setTextAlignment:NSTextAlignmentCenter];
    [userNameLabel setText:@"maxsvg"];
    userNameLabel.font = SOONZIK_FONT_BODY_BIG;
    [self.menuUserPreview addSubview:userNameLabel];
}

- (void)displayMenu
{
    if (self.searchOpened) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.searchView setFrame:CGRectMake(self.searchView.frame.size.width, self.searchView.frame.origin.y, self.searchView.frame.size.width, self.searchView.frame.size.height)];
        } completion:nil];
        self.searchOpened = NO;
    }
    if (self.menuOpened) {
        //  when we close
        [self closeTheMenuView];
    } else {
        // when we open
        [self openTheMenuView];
    }
}

- (void)displaySearch
{
    if (self.menuOpened) {
        [self closeTheMenuView];
    }
    if (self.searchOpened) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.searchView setFrame:CGRectMake(self.searchView.frame.size.width, self.searchView.frame.origin.y, self.searchView.frame.size.width, self.searchView.frame.size.height)];
        } completion:nil];
        self.searchOpened = NO;
    } else {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.searchView setFrame:CGRectMake(0, self.searchView.frame.origin.y, self.searchView.frame.size.width, self.searchView.frame.size.height)];
        } completion:nil];
        self.searchOpened = YES;
    }
}

- (void)clickedAtIndex:(int)index
{
    [self closeTheMenuView];
    
    self.selectedMenuIndex = index;
    
    [self performSelector:@selector(launchView) withObject:self afterDelay:0.5];
    
}

- (void)launchView
{
    UIViewController *vc = nil;

    switch (self.selectedMenuIndex) {
        case 0:
            // fil d'actualité
            vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            break;
        case 1:
            // explorer
            vc = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController" bundle:nil];
            break;
        case 2:
            // pack
            vc = [[WeekPackViewController alloc] initWithNibName:@"WeekPackViewController" bundle:nil];
            break;
        case 3:
            // monde musical
            vc = [[GeolocationViewController alloc] initWithNibName:@"GeolocationViewController" bundle:nil];
            break;
        case 4:
            // battles
            vc = [[BattleViewController alloc] initWithNibName:@"BattleViewController" bundle:nil];
            break;
        case 5:
            // playlists
            vc = [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
            break;
        case 6:
            // playlists
            vc = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)refreshThePlayerPreview
{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshPreview) userInfo:nil repeats:YES];
}

- (void)refreshPreview
{
    if (self.player.listeningList.count > 0) {
        //
        if (!self.player.currentlyPlaying) {
            [self.playerPreviewView.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
        } else {
            [self.playerPreviewView.playButton setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
        }
        
        Song *s = [self.player.listeningList objectAtIndex:self.player.index];
        
        if (self.player.audioPlayer != nil) {
            int current = self.player.audioPlayer.currentTime;
            int duration = self.player.audioPlayer.duration;
            self.playerPreviewView.timeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d / %.02d:%.02d", current/60, current%60, duration/60, duration%60];
            NSLog(@"current time = %i", current);
        } else {
            [self.player prepareSong:s.file];
        }

        self.playerPreviewView.trackLabel.text = s.title;
        self.playerPreviewView.artistLabel.text = s.artist;
        self.playerPreviewView.imageView.image = [UIImage imageNamed:s.image];
        
    } else {
        self.playerPreviewView.imageView.image = [UIImage imageNamed:@"empty_list.png"];
        [self.playerPreviewView.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
        self.player.audioPlayer.currentTime = 0;
        self.playerPreviewView.timeLabel.text = @"00:00 / 00:00";
        self.playerPreviewView.artistLabel.text = @"";
        self.playerPreviewView.trackLabel.text = @"";
    }
}

- (void)play
{
    NSLog(@"play");
    
    if (self.player.listeningList.count > 0) {
        
        Song *s = [self.player.listeningList objectAtIndex:self.player.index];
        
        if (!self.player.currentlyPlaying) {
            [self.playerPreviewView.playButton setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
            [self.player playSound];
            self.player.songName = s.title;
        } else {
            [self.playerPreviewView.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
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
            Song *s = [self.player.listeningList objectAtIndex:self.player.index];
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
            Song *s = [self.player.listeningList objectAtIndex:self.player.index];
            [self.player prepareSong:s.file];
            [self.player playSound];
            self.player.songName = s.title;
        } else if (self.player.repeatingLevel == 1) {
            if (self.player.index == self.player.listeningList.count - 1) {
                self.player.index = 0;
            } else {
                self.player.index++;
            }
            Song *s = [self.player.listeningList objectAtIndex:self.player.index];
            [self.player prepareSong:s.file];
            [self.player playSound];
            self.player.songName = s.title;
        } else if (self.player.repeatingLevel == 0) {
            if (self.player.index < self.player.listeningList.count - 1) {
                self.player.index++;
                Song *s = [self.player.listeningList objectAtIndex:self.player.index];
                [self.player prepareSong:s.file];
                if (self.player.currentlyPlaying) {
                    [self.player playSound];
                    self.player.songName = s.title;
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
