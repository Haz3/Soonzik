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

- (void)prepareSong:(NSString *)song
{
    //NSLog(@"song : %@", song);
    NSString *data = [[NSBundle mainBundle] pathForResource:song ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:data];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
}

- (void)playSound
{
    if (self.listeningList.count > 0) {
        if (!self.currentlyPlaying) {
            //[self.playButton setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
            //[self.player playSound];
            [self.audioPlayer play];
            self.currentlyPlaying = YES;
            Music *s = [self.listeningList objectAtIndex:self.index];
            self.songName = s.title;
            
        } else {
            //[self.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
            [self pauseSound];
        }
    }
    /*[self.audioPlayer play];
    
    self.currentlyPlaying = YES;*/
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
    [self.audioPlayer stop];
    
    self.currentlyPlaying = NO;
}

- (void)previous
{
    if (self.listeningList.count > 0) {
        if (self.index > 0) {
            self.index--;
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self prepareSong:s.file];
            if (self.currentlyPlaying) {
                [self playSound];
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
            [self prepareSong:s.file];
            [self playSound];
            self.songName = s.title;
        } else if (self.repeatingLevel == 1) {
            if (self.index == self.listeningList.count - 1) {
                self.index = 0;
            } else {
                self.index++;
            }
            Music *s = [self.listeningList objectAtIndex:self.index];
            [self prepareSong:s.file];
            [self playSound];
            self.songName = s.title;
        } else if (self.repeatingLevel == 0) {
            if (self.index < self.listeningList.count - 1) {
                self.index++;
                Music *s = [self.listeningList objectAtIndex:self.index];
                [self prepareSong:s.file];
                if (self.currentlyPlaying) {
                    [self playSound];
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
            // repeat the list when it's finished
            NSLog(@"Repeating all");
            self.repeatingLevel = 1;
            break;
        case 1:
            // just repeat this one indefinely only
            NSLog(@"Repeating one");
            self.repeatingLevel = 2;
            [self.audioPlayer setNumberOfLoops:-1];
            break;
        case 2:
            // stop the repeating action
            NSLog(@"NO Repeating");
            self.repeatingLevel = 0;
            [self.audioPlayer setNumberOfLoops:0];
            break;
        default:
            break;
    }
}

/*

- (IBAction)mute:(id)sender
{
    if (!self.isMute) {
        self.lastVolumeLevel = self.player.audioPlayer.volume;
        self.volumeSlider.value = 0;
        self.player.audioPlayer.volume = 0;
    } else {
        self.volumeSlider.value = self.lastVolumeLevel;
        self.player.audioPlayer.volume = self.lastVolumeLevel;
    }
}

*/


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.currentlyPlaying = NO;
    [self.finishDelegate playerHasFinishedToPlay];
}

@end
