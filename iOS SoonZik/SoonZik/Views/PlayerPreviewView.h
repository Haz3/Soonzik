//
//  PlayerPreviewView.h
//  SoonZik
//
//  Created by Maxime on 24/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerPreviewDelegate <NSObject>

- (void)play;
- (void)next;
- (void)previous;

@end

@interface PlayerPreviewView : UIView

@property (nonatomic, strong) id<PlayerPreviewDelegate> actionDelegate;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *trackLabel;
@property (nonatomic, strong) UILabel *artistLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *nextButton;

@end
