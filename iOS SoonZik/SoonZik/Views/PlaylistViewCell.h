//
//  PlaylistViewCell.h
//  SoonZik
//
//  Created by LLC on 18/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "MusicOptionsButton.h"

@interface PlaylistViewCell : SWTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *songTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet MusicOptionsButton *optionsButton;

- (void)initCell;

@end
