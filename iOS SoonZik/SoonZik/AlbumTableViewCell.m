//
//  AlbumTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "SVGKImage.h"
#import "Tools.h"

@implementation AlbumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell
{
    [self.optionsButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"music_options"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
}

@end
