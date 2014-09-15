//
//  OnLTMusicPopupView.h
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface OnLTMusicPopupView : UIView

@property (nonatomic, weak) IBOutlet UIView *popupView;

@property (nonatomic, weak) IBOutlet UIButton *removeFromPlaylistButton;

@property (nonatomic, weak) IBOutlet UIImageView *musicImage;
@property (nonatomic, weak) IBOutlet UILabel *musicName;

- (void)initPopupWithSong:(Song *)song;

@end
