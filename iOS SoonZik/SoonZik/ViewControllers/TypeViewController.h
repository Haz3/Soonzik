//
//  TypeViewController.h
//  SoonZik
//
//  Created by devmac on 27/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuTabDelegate.h"
#import "MenuTabView.h"
#import "SearchTabView.h"
#import "PlayerPreviewView.h"
#import "AudioPlayer.h"
#import "Music.h"
#import "LoadingView.h"
#import "TitleSongPreview.h"

@interface TypeViewController : UIViewController <MenuTabDelegate, FinishPlayPlayer, PlayerPreviewDelegate>

@property (nonatomic, strong) NSUserDefaults *prefs;

@property (strong, nonatomic) AudioPlayer *player;

@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIView *menuUserPreview;
@property (strong, nonatomic) MenuTabView *menuTableView;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) SearchTabView *searchTableView;
@property (strong, nonatomic) LoadingView *loadingView;

@property (assign, nonatomic) CGFloat statusBarHeight;

@property (assign, nonatomic) bool menuOpened;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSMutableArray *tableImageData;
@property (assign, nonatomic) bool searchOpened;

@property (assign, nonatomic) int selectedMenuIndex;

@property (strong, nonatomic) PlayerPreviewView *playerPreviewView;

- (void)displaySearch;
- (void)closeTheMenuView;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (void)addBlurEffectOnView:(UIView *)view;
- (void)removeBlurEffect:(int)tag onView:(UIView *)v;

@end
