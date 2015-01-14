//
//  OnLTMusicPopupView.m
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "OnLTMusicPopupView.h"
#import "Tools.h"
#import "SVGKImage.h"

@implementation OnLTMusicPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initPopupWithSong:(Music *)song andPlaylist:(Playlist *)playlist
{
    self.alpha = 0;
    self.song = song;
    self.playlist = playlist;
    
    self.popupView.layer.cornerRadius = 10;
    
    //[self.popupView setFrame:CGRectMake(self.popupView.frame.origin.x, self.popupView.frame.origin.y, self.popupView.frame.size.width, self.popupView.frame.size.height)];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    
    self.musicImage.image = [UIImage imageNamed:song.image];
    self.musicName.text = song.title;
    
    [self.removeFromPlaylistButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"remove_from_playlist"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.removeFromPlaylistButton setTintColor:[UIColor whiteColor]];
    [self.albumButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"album"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.albumButton setTintColor:[UIColor whiteColor]];
    [self.artistButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"user"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.artistButton setTintColor:[UIColor whiteColor]];
    [self.addToPlaylistButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"play_later"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.addToPlaylistButton setTintColor:[UIColor whiteColor]];
    
    [self.removeFromPlaylistButton addTarget:self action:@selector(removeFromPlayList) forControlEvents:UIControlEventTouchUpInside];
    [self.albumButton addTarget:self action:@selector(pressAlbumButton) forControlEvents:UIControlEventTouchUpInside];
    [self.artistButton addTarget:self action:@selector(pressArtistButton) forControlEvents:UIControlEventTouchUpInside];
    [self.addToPlaylistButton addTarget:self action:@selector(pressAddToCurrentPlaylistButton) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ((point.x < self.popupView.frame.origin.x) || (point.x > (self.popupView.frame.origin.x + self.popupView.frame.size.width))) {
       [self.choiceDelegate closePopUpView];
    } else if ((point.y < self.popupView.frame.origin.y) || (point.y > (self.popupView.frame.origin.y + self.popupView.frame.size.height))) {
        [self.choiceDelegate closePopUpView];
    }
    
    return YES;
}

- (void)removeFromPlayList
{
    [self.choiceDelegate removeMusicFromPlayList:self.song and:self.playlist];
}

- (void)pressAlbumButton
{
    [self.choiceDelegate goToAlbumView:self.song];
}

- (void)pressArtistButton
{
    [self.choiceDelegate goToArtistView:self.song];
}

- (void)pressAddToCurrentPlaylistButton
{
    [self.choiceDelegate addToCurrentPlaylist:self.song];
}

@end
