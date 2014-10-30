//
//  PlayerViewController.m
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlaylistViewCell.h"
#import "AppDelegate.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone5_background.jpg"]]];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.screenHeight = screenSize.size.height;
    self.screenWidth = screenSize.size.width;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    self.playerArea.layer.shadowColor = [UIColor blackColor].CGColor;
    self.playerArea.layer.shadowOpacity = 1;
    self.playerArea.layer.shadowRadius = 10;
    self.playerArea.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self.progressionSlider setThumbImage:[UIImage imageNamed:@"cursor.png"] forState:UIControlStateNormal];
    
    self.songTitle.font = SOONZIK_FONT_BODY_BIG;
    self.songArtist.font = SOONZIK_FONT_BODY_MEDIUM;
    
    self.currentTimeLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
    self.finishTimeLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem.title = @"";
    
    self.playlistTableView.delegate = self;
    self.playlistTableView.dataSource = self;
    
    self.isMute = NO;
    
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player.finishDelegate = self;
    
    if (self.player.listeningList.count == 0) {
        NSLog(@"self.player.listeningList vide");
        [self.player prepareSong:0];
    }
    
    [self refresh];
    
    self.volumeSlider.value = self.player.audioPlayer.volume;
    self.lastVolumeLevel = self.player.audioPlayer.volume;
    
    [self.playlistTableView reloadData];
    [self updateListeningCells];
}

- (void)refresh
{
    if (self.player.listeningList.count > 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshDisplay) userInfo:nil repeats:YES];
        
        [self.progressionSlider setMinimumValue:0.0];
        [self.progressionSlider setMaximumValue:self.player.audioPlayer.duration];
    } else {
        [self.progressionSlider setValue:0.0];
        [self.progressionSlider setMaximumValue:self.player.audioPlayer.duration];
        int duration = 0;
        self.finishTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", duration/60, duration%60];
        
        int current = 0;
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", current/60, current%60];
    }
}

- (void)refreshDisplay
{
    if (self.player.listeningList.count > 0) {
        if (!self.player.currentlyPlaying) {
            [self.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
        } else {
            [self.playButton setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
        }
        
        int duration = self.player.audioPlayer.duration;
        self.finishTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", duration/60, duration%60];
        
        int current = self.player.audioPlayer.currentTime;
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", current/60, current%60];
        
        [self.progressionSlider setValue:current];
        
        Music *s = [self.player.listeningList objectAtIndex:self.player.index];
        self.title = s.title;
        self.songTitle.text = s.title;
        self.songArtist.text = s.artist.username;
        self.songImage.image = [UIImage imageNamed:s.album.image];
    }
    
}

- (IBAction)goToThisPeriod:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    if (slider.value >= self.player.audioPlayer.duration) {
        [self.player pauseSound];
        [self next:nil];
    } else {
       [self.player playSoundAtPeriod:slider.value]; 
    }
    
}

- (IBAction)changeVolume:(id)sender
{
    UISlider *slider = sender;
    self.player.audioPlayer.volume = slider.value;
    self.lastVolumeLevel = slider.value;
}

- (IBAction)play:(id)sender
{
    if (self.player.listeningList.count > 0) {
        if (!self.player.currentlyPlaying) {
            [self.playButton setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
            [self.player playSound];
            Music *s = [self.player.listeningList objectAtIndex:self.player.index];
            self.player.songName = s.title;
            self.player.audioPlayer.volume = self.lastVolumeLevel;
            [self updateListeningCells];
        } else {
            [self.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
            [self.player pauseSound];
        }
    }
    
}

- (IBAction)previous:(id)sender
{
    if (self.player.listeningList.count > 0) {
        if (self.player.index > 0) {
            self.player.index--;
            Music *s = [self.player.listeningList objectAtIndex:self.player.index];
            [self.player prepareSong:s.file];
            if (self.player.currentlyPlaying) {
                [self.player playSound];
                self.player.songName = s.title;
            }
        };
        self.player.audioPlayer.volume = self.lastVolumeLevel;
        
        [self updateListeningCells];
    }
    
}

- (IBAction)next:(id)sender
{
        if (self.player.listeningList.count > 0) {
            if (self.player.repeatingLevel == 2) {
                Music *s = [self.player.listeningList objectAtIndex:self.player.index];
                [self.player prepareSong:s.file];
                [self.player playSound];
                self.player.songName = s.title;
            } else if (self.player.repeatingLevel == 1) {
                if (self.player.index == self.player.listeningList.count - 1) {
                    self.player.index = 0;
                } else {
                    self.player.index++;
                }
                Music *s = [self.player.listeningList objectAtIndex:self.player.index];
                [self.player prepareSong:s.file];
                [self.player playSound];
                self.player.songName = s.title;
            } else if (self.player.repeatingLevel == 0) {
                if (self.player.index < self.player.listeningList.count - 1) {
                    self.player.index++;
                    Music *s = [self.player.listeningList objectAtIndex:self.player.index];
                    [self.player prepareSong:s.file];
                    if (self.player.currentlyPlaying) {
                        [self.player playSound];
                        self.player.songName = s.title;
                    }
                }
            }
            
            self.player.audioPlayer.volume = self.lastVolumeLevel;
            
            [self updateListeningCells];
        }
}

- (void)playerHasFinishedToPlay
{
    NSLog(@"LECTURE TERMINEE");
    [self next:nil];
}

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

- (IBAction)random:(id)sender
{
    
}

- (IBAction)repeat:(id)sender
{
    [self.player repeat];
    switch (self.player.repeatingLevel) {
        case 0:
            // repeat the list when it's finished
            NSLog(@"Repeating all");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-1_icon.png"] forState:UIControlStateNormal];
            self.player.repeatingLevel = 1;
            break;
        case 1:
            // just repeat this one indefinely only
            NSLog(@"Repeating one");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-2_icon.png"] forState:UIControlStateNormal];
            self.player.repeatingLevel = 2;
            [self.player.audioPlayer setNumberOfLoops:-1];
            break;
        case 2:
            // stop the repeating action
            NSLog(@"NO Repeating");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-0_icon.png"] forState:UIControlStateNormal];
            self.player.repeatingLevel = 0;
            [self.player.audioPlayer setNumberOfLoops:0];
            break;
        default:
            break;
    }
}

- (void)updateListeningCells
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.index inSection:0];
    [self.playlistTableView.delegate tableView:self.playlistTableView didSelectRowAtIndexPath:indexPath];
    
    for (int i=0; i < self.player.listeningList.count; i++) {
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
        if (i != self.player.index)
            [self.playlistTableView.delegate tableView:self.playlistTableView didDeselectRowAtIndexPath:indexPath2];
    }
}

/*
 *  TableView
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.player.listeningList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    PlaylistViewCell *cell = (PlaylistViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PlaylistViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    UIImage *deleteImage = [UIImage imageNamed:@"delete_icon.png"];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-30, 10, 15, 15)];
    deleteButton.tag = indexPath.row;
    [deleteButton setImage:deleteImage forState:UIControlStateNormal];
    [cell addSubview:deleteButton];
    
    [deleteButton addTarget:self action:@selector(removeElementFromPlaylist:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell initCell];
    Music *s = [self.player.listeningList objectAtIndex:indexPath.row];
    cell.songTitleLabel.text = s.title;
    cell.imageAlbum.image = [UIImage imageNamed:s.album.image];
    
    return cell;
}

- (void)removeElementFromPlaylist:(UIButton *)btn
{
    NSMutableArray *tmpSongList = self.player.listeningList;
    NSString *element = [tmpSongList objectAtIndex:btn.tag];
    [tmpSongList removeObject:element];
    self.listeningList = [[NSMutableArray alloc] init];
    for (NSString *element in tmpSongList)
        [self.listeningList addObject:element];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
    self.player.listeningList = [[NSMutableArray alloc] initWithArray:self.listeningList];
    
    NSLog(@"taille tab: %i", self.player.listeningList.count);
    
    if (self.player.index == btn.tag) {
        [self.player pauseSound];
        self.player.index = 0;
        if (self.player.listeningList.count > 0) {
            Music *s = [self.player.listeningList objectAtIndex:self.player.index];
            if (![s.title isEqualToString:self.player.songName]) {
                NSString *data = [[NSBundle mainBundle] pathForResource:s.file ofType:@"mp3"];
                NSURL *url = [[NSURL alloc] initFileURLWithPath:data];
                self.player.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                self.player.audioPlayer.currentTime = 0.0;
            }
            
        }
        
    } else if (self.player.listeningList.count == 1) {
        self.player.index = 0;
        
    } else if (self.player.index >= self.player.listeningList.count) {
        self.player.index--;
    }

    
    if (self.player.listeningList.count <= 0) {
        [self.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
        self.player.currentlyPlaying = NO;
    }
    
    NSLog(@"self.player.index: %i", self.player.index);
    
    [self.playlistTableView reloadData];
    [self updateListeningCells];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.player.index = indexPath.row;
    
    if (self.player.oldIndex != self.player.index && self.player.listeningList.count > 1) {
        self.player.oldIndex = self.player.index;
    
        Music *s = [self.player.listeningList objectAtIndex:self.player.index];
        [self.player prepareSong:s.file];
        self.player.audioPlayer.volume = self.lastVolumeLevel;
        [self.player playSound];
        self.player.songName = s.title;
        [self updateListeningCells];
    }
    
    [self refresh];
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
    
    [self.playButton setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
