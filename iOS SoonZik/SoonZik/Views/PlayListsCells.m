//
//  PlayListsCells.m
//  SoonZik
//
//  Created by LLC on 25/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlayListsCells.h"

@implementation PlayListsCells

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initCell
{
    self.trackTitle.font = SOONZIK_FONT_BODY_SMALL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
