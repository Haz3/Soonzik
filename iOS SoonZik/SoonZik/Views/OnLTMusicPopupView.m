//
//  OnLTMusicPopupView.m
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "OnLTMusicPopupView.h"

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
    float yPosition = self.popupView.frame.origin.y;
    self.song = song;
    self.playlist = playlist;
    
    self.popupView.layer.cornerRadius = 15;
    
    [self.popupView setFrame:CGRectMake(self.popupView.frame.origin.x, self.frame.size.height, self.popupView.frame.size.width, self.popupView.frame.size.height)];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.popupView setFrame:CGRectMake(self.popupView.frame.origin.x, yPosition, self.popupView.frame.size.width, self.popupView.frame.size.height)];
    }];
    
    self.musicImage.image = [UIImage imageNamed:song.image];
    self.musicName.text = song.title;
    
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
    NSLog(@"Remove from playlist");
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
