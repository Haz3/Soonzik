//
//  AudioPlayer.m
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMediaQuery.h>

#import "AudioPlayer.h"
#import "Music.h"

@implementation AudioPlayer

static AudioPlayer *sharedInstance = nil;

+ (AudioPlayer *)sharedCenter {
    if (sharedInstance == nil) {
        sharedInstance = [[AudioPlayer alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.index = 0;
        self.oldIndex = 0;
        self.listeningList = [[NSMutableArray alloc] init];
        self.currentlyPlaying = true;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    return self;
}

- (void)prepareSong:(int)identifier
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *key = [Crypto getKey:user.identifier];
    NSString *conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    NSString *secureKey = [Crypto sha256HashFor:conca];
    NSString *url = [NSString stringWithFormat:@"%@musics/get/%i?user_id=%i&secureKey=%@", API_URL, identifier, user.identifier, secureKey];
    
 //   NSLog(@"url of the music : %@", url);
    //NSURL *nurl = [NSURL URLWithString:url];
    
    
    
    self.audioPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.audioPlayer currentItem]];
    [self.audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
 //   [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}

- (void)deleteCurrentPlayer {
    @try{
        [self.audioPlayer removeObserver:self forKeyPath:@"status"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.audioPlayer && [keyPath isEqualToString:@"status"]) {
        if (self.audioPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            self.currentlyPlaying = NO;
            
        } else if (self.audioPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
           // if (self.currentlyPlaying) {
                [self.audioPlayer play];
            self.currentlyPlaying = true;
            //}
            
        } else if (self.audioPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            self.currentlyPlaying = NO;
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    //  code here to play next sound file
    NSLog(@"finished to play");
    [self deleteCurrentPlayer];
    [self next];
}


/*- (void)prepareSong:(int)identifier
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *key = [Crypto getKey:user.identifier];
    NSString *conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    NSString *secureKey = [Crypto sha256HashFor:conca];
    NSString *url = [NSString stringWithFormat:@"%@musics/get/%i?user_id=%i&secureKey=%@", API_URL, identifier, user.identifier, secureKey];
    
    NSLog(@"url of the music : %@", url);
    NSURL *nurl = [NSURL URLWithString:url];
    NSData *ndata = [NSData dataWithContentsOfURL:nurl];

    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:ndata error:&error];
    self.audioPlayer.delegate = self;
}*/

- (void)playSound
{
    [self.audioPlayer play];
    self.currentlyPlaying = true;
}

- (void)playSoundAtPeriod:(float)period
{
    [self.audioPlayer seekToTime:CMTimeMake(period, 1)];
}

- (void)pauseSound
{
    [self.audioPlayer pause];
    self.currentlyPlaying = NO;
}

- (void)stopSound
{
    [self.audioPlayer pause];
    [self.audioPlayer seekToTime:CMTimeMake(0, 0)];
    
    self.currentlyPlaying = NO;
}

- (void)previous
{
    NSLog(@"prev");
    [self deleteCurrentPlayer];
    if (self.listeningList.count > 0) {
        if (self.index > 0) {
            self.index--;
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self prepareSong:s.identifier];
            if (self.currentlyPlaying) {
                //[self.audioPlayer play];
                self.songName = s.title;
            }
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:s.title, s.artist.username, nil]
                                                                           forKeys:[NSArray arrayWithObjects: MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, nil]];
            
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
        };
    }
}

- (void)next
{
    NSLog(@"next");
    [self deleteCurrentPlayer];
    if (self.listeningList.count > 0) {
        if (self.index < self.listeningList.count - 1) {
            self.index++;
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self prepareSong:s.identifier];
            if (self.currentlyPlaying) {
                self.songName = s.title;
            }
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:s.title, s.artist.username, nil]
                                                                           forKeys:[NSArray arrayWithObjects: MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, nil]];
            
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
        }
    } else {
        self.currentlyPlaying = NO;
        [self.finishDelegate playerHasFinishedToPlay];
    }
}

@end
