//
//  PlaylistViewCell.m
//  SoonZik
//
//  Created by LLC on 18/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlaylistViewCell.h"

@implementation PlaylistViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initCell
{
    [self.layerListening setHidden:YES];
}

- (void)setSelected:(BOOL)selected
{
    if (selected == YES) {
        [self.layerListening setHidden:NO];
        [self setBackgroundColor:[UIColor grayColor]];
    } else {
        [self.layerListening setHidden:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
}

@end
