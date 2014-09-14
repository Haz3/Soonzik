//
//  PlayerPreviewView.m
//  SoonZik
//
//  Created by Maxime on 24/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlayerPreviewView.h"
#import "AllTheIncludes.h"

@implementation PlayerPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PREVIEW_HEIGHT, PREVIEW_HEIGHT)];
        [self addSubview:self.imageView];
        
        self.trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width + PREVIEW_HEIGHT*0.2, PREVIEW_HEIGHT*0.1, 200, PREVIEW_HEIGHT/2)];
        self.trackLabel.font = SOONZIK_FONT_BODY_MEDIUM;
        [self addSubview:self.trackLabel];
        
        self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width + PREVIEW_HEIGHT*0.2, self.trackLabel.frame.size.height, 170, PREVIEW_HEIGHT/2)];
        self.artistLabel.font = SOONZIK_FONT_BODY_SMALL;
        [self addSubview:self.artistLabel];
        
        self.prevButton = [[UIButton alloc] initWithFrame:CGRectMake(self.artistLabel.frame.origin.x + self.artistLabel.frame.size.width, PREVIEW_HEIGHT*0.5, 20, 20)];
        [self.prevButton setImage:[UIImage imageNamed:@"previous_icon.png"] forState:UIControlStateNormal];
        [self addSubview:self.prevButton];
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.prevButton.frame.origin.x + self.prevButton.frame.size.width + 5, PREVIEW_HEIGHT*0.5, 20, 20)];
        [self.playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
        [self addSubview:self.playButton];
        
        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width + 5, PREVIEW_HEIGHT*0.5, 20, 20)];
        [self.nextButton setImage:[UIImage imageNamed:@"next_icon.png"] forState:UIControlStateNormal];
        [self addSubview:self.nextButton];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, PREVIEW_HEIGHT * 0.005, 80, PREVIEW_HEIGHT * 0.5)];
        self.timeLabel.text = @"--:-- / --:--";
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
        [self addSubview:self.timeLabel];
        
        
        [self.prevButton addTarget:self action:@selector(previousSong) forControlEvents:UIControlEventTouchUpInside];
        [self.playButton addTarget:self action:@selector(playSong) forControlEvents:UIControlEventTouchUpInside];
        [self.nextButton addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)previousSong
{
    [self.actionDelegate previous];
}

- (void)playSong
{
    [self.actionDelegate play];
}

- (void)nextSong
{
    [self.actionDelegate next];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
