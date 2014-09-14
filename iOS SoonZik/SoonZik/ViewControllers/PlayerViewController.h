//
//  PlayerViewController.h
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "Song.h"

@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FinishPlayPlayer>

@property (nonatomic, retain) AudioPlayer *player;

@property (nonatomic, weak) IBOutlet UIView *playerArea;

@property (nonatomic, strong) NSMutableArray *listeningList;

@property (nonatomic, weak) IBOutlet UITableView *playlistTableView;

@property (nonatomic, weak) IBOutlet UILabel *finishTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;

@property (nonatomic, weak) IBOutlet UISlider *progressionSlider;
@property (nonatomic, weak) IBOutlet UISlider *volumeSlider;

@property (assign, nonatomic) CGFloat screenWidth;
@property (assign, nonatomic) CGFloat screenHeight;

@property (assign, nonatomic) bool isRandom;

@property (nonatomic, assign) bool isMute;

@property (nonatomic, assign) float lastVolumeLevel;

@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *songArtist;


@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;

- (IBAction)play:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)mute:(id)sender;

- (IBAction)random:(id)sender;
- (IBAction)repeat:(id)sender;

- (IBAction)goToThisPeriod:(id)sender;
- (IBAction)changeVolume:(id)sender;

@end
