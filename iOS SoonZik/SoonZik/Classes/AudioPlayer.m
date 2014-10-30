//
//  AudioPlayer.m
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AudioPlayer.h"

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
    NSString *data = [[NSBundle mainBundle] pathForResource:song ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:data];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
}

- (void)playSound
{
    [self.audioPlayer play];
    
    self.currentlyPlaying = YES;
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.currentlyPlaying = NO;
    [self.finishDelegate playerHasFinishedToPlay];
    
}

@end
