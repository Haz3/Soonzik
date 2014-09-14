//
//  AlbumSongCell.m
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AlbumSongCell.h"

@implementation AlbumSongCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell
{
    self.songTitle.font = SOONZIK_FONT_BODY_VERY_SMALL;
}

@end
