//
//  AudioPlayer.m
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AudioPlayer.h"
#import "Music.h"

@implementation AudioPlayer

static AudioPlayer *sharedInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
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
    
    NSLog(@"url of the music : %@", url);
    NSURL *nurl = [NSURL URLWithString:url];
    NSData *ndata = [NSData dataWithContentsOfURL:nurl];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:ndata error:nil];
    self.audioPlayer.delegate = self;
}

- (void)playSound
{
    if (self.listeningList.count > 0) {
        if (!self.currentlyPlaying) {
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self.audioPlayer play];
            self.currentlyPlaying = YES;
            self.songName = s.title;
            
        } else {
            [self pauseSound];
            self.currentlyPlaying = NO;
        }
    }
}

- (void)playSoundAtPeriod:(float)period
{
    self.audioPlayer.currentTime = period;
}

- (void)pauseSound
{
    [self.audioPlayer pause];
    
    self.currentlyPlaying = NO;
}

- (void)stopSound
{
    [self.audioPlayer pause];
    self.audioPlayer.currentTime = 0.0;
    
    self.currentlyPlaying = NO;
}

- (void)previous
{
    if (self.listeningList.count > 0) {
        if (self.index > 0) {
            self.index--;
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self prepareSong:s.identifier];
            if (self.currentlyPlaying) {
                [self.audioPlayer play];
                self.currentlyPlaying = YES;
                self.songName = s.title;
            }
        };
    }
}

- (void)next
{
    if (self.listeningList.count > 0) {
        if (self.repeatingLevel == 2) {
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self prepareSong:s.identifier];
            [self playSound];
            self.songName = s.title;
        } else if (self.repeatingLevel == 1) {
            if (self.index == self.listeningList.count - 1) {
                self.index = 0;
            } else {
                self.index++;
            }
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self prepareSong:s.identifier];
            [self playSound];
            self.songName = s.title;
        } else if (self.repeatingLevel == 0) {
            if (self.index < self.listeningList.count - 1) {
                self.index++;
                Music *s = [self.listeningList objectAtIndex:self.index];
                [self prepareSong:s.identifier];
                if (self.currentlyPlaying) {
                    [self.audioPlayer play];
                    self.currentlyPlaying = YES;
                    self.songName = s.title;
                }
            }
        }
    }
}

- (void)repeat
{
    switch (self.repeatingLevel) {
        case 0:
            // repeat on all the playlist
            self.repeatingLevel = 1;
            break;
        case 1:
            // repeat only on a music
            self.repeatingLevel = 2;
            [self.audioPlayer setNumberOfLoops:-1];
            break;
        case 2:
            // no repeat
            self.repeatingLevel = 0;
            [self.audioPlayer setNumberOfLoops:0];
            break;
        default:
            break;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.currentlyPlaying = NO;
    [self.finishDelegate playerHasFinishedToPlay];
}

@end
