//
//  OnLTMusicPopupView.h
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "Playlist.h"

@protocol PopUpDetailMusicDelegate <NSObject>

- (void)goToAlbumView:(Music *)music;
- (void)goToArtistView:(Music *)music;
- (void)addToCurrentPlaylist:(Music *)music;
- (void)removeMusicFromPlayList:(Music *)music and:(Playlist *)playlist;
- (void)closePopUpView;

@end

@interface OnLTMusicPopupView : UIView

@property (nonatomic, weak) IBOutlet UIView *popupView;

@property (nonatomic, weak) IBOutlet UIButton *removeFromPlaylistButton;
@property (nonatomic, weak) IBOutlet UIButton *artistButton;
@property (nonatomic, weak) IBOutlet UIButton *albumButton;
@property (nonatomic, weak) IBOutlet UIButton *addToPlaylistButton;

@property (nonatomic, weak) IBOutlet UIImageView *musicImage;
@property (nonatomic, weak) IBOutlet UILabel *musicName;

@property (nonatomic, strong) Playlist *playlist;
@property (nonatomic, strong) Music *song;

@property (nonatomic, strong) id<PopUpDetailMusicDelegate> choiceDelegate;

- (void)initPopupWithSong:(Music *)song andPlaylist:(Playlist *)playlist;

@end
