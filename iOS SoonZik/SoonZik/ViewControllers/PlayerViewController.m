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
#import "Tools.h"
#import "SVGKImage.h"

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
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.navigationItem.hidesBackButton = YES;
    UIImage *closeImage = [Tools imageWithImage:[SVGKImage imageNamed:@"close"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(closePlayerViewController)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
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

- (void)closePlayerViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem.title = @"";
    
    self.playlistTableView.delegate = self;
    self.playlistTableView.dataSource = self;
    
    self.playlistTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.playlistTableView.backgroundColor = [UIColor darkGrayColor];
    
    self.isMute = NO;
    
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player.finishDelegate = self;
    
    if (self.player.listeningList.count == 0)
    {
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
        self.songImage.image = [UIImage imageNamed:s.image];
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
    [self.player playSound];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
    
    [self updateListeningCells];
}

- (IBAction)previous:(id)sender
{
    [self.player previous];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
        
    [self updateListeningCells];
}

- (IBAction)next:(id)sender
{
    [self.player next];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
        
    [self updateListeningCells];
}

- (void)playerHasFinishedToPlay
{
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
    switch (self.player.repeatingLevel) {
        case 0:
            // repeat the list when it's finished
            NSLog(@"Repeating all");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-1_icon.png"] forState:UIControlStateNormal];
            break;
        case 1:
            // just repeat this one indefinely only
            NSLog(@"Repeating one");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-2_icon.png"] forState:UIControlStateNormal];
            break;
        case 2:
            // stop the repeating action
            NSLog(@"NO Repeating");
            [self.repeatButton setImage:[UIImage imageNamed:@"repeat-0_icon.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [self.player repeat];
}

- (void)updateListeningCells
{
    /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.index inSection:0];
    [self.playlistTableView.delegate tableView:self.playlistTableView didSelectRowAtIndexPath:indexPath];
    
    for (int i=0; i < self.player.listeningList.count; i++) {
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
        if (i != self.player.index)
            [self.playlistTableView.delegate tableView:self.playlistTableView didDeselectRowAtIndexPath:indexPath2];
    }*/
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    PlaylistViewCell *cell = (PlaylistViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PlaylistViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell initCell];
    Music *s = [self.player.listeningList objectAtIndex:indexPath.row];
    cell.songTitleLabel.text = s.title;
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:BLUE_2 icon:[Tools imageWithImage:[SVGKImage imageNamed:@"delete"].UIImage scaledToSize:CGSizeMake(30, 30)]];

    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [self removeElementFromPlaylist:index];
            break;
        }
        default:
            break;
    }
}


- (void)removeElementFromPlaylist:(int)index
{
    NSMutableArray *tmpSongList = self.player.listeningList;
    NSString *element = [tmpSongList objectAtIndex:index];
    [tmpSongList removeObject:element];
    self.listeningList = [[NSMutableArray alloc] init];
    for (NSString *element in tmpSongList)
        [self.listeningList addObject:element];
    self.player.audioPlayer.volume = self.lastVolumeLevel;
    self.player.listeningList = [[NSMutableArray alloc] initWithArray:self.listeningList];
    
    if (self.player.index == index) {
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
    
    [self.playlistTableView reloadData];
    [self updateListeningCells];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.player.index = indexPath.row;
    
    NSLog(@"oldIndex : %i", self.player.oldIndex);
    NSLog(@"newIndex : %i", self.player.index);
    
    if (self.player.oldIndex != self.player.index && self.player.listeningList.count > 1) {
        self.player.oldIndex = self.player.index;
        //NSLog(@"ok");
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
   // [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
