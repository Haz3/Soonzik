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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)initPopupWithSong:(Song *)song
{
    self.alpha = 0;
    float yPosition = self.popupView.frame.origin.y;
    
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
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    self.superview.userInteractionEnabled = NO;
    if ((point.x < self.popupView.frame.origin.x) || (point.x > (self.popupView.frame.origin.x + self.popupView.frame.size.width))) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.superview.userInteractionEnabled = YES;
                [self removeFromSuperview];
            }
        }];
       
        
    } else if ((point.y < self.popupView.frame.origin.y) || (point.y > (self.popupView.frame.origin.y + self.popupView.frame.size.height))) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.superview.userInteractionEnabled = YES;
                [self removeFromSuperview];
            }
        }];
    }
    else {
        self.superview.userInteractionEnabled = YES;
    }
    
    NSLog(@"user enabled : %i", self.popupView.isUserInteractionEnabled);
    
    return YES;
}

- (void)removeFromPlayList
{
    NSLog(@"Remove from playlist");
}

@end
