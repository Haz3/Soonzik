//
//  MenuTableViewCell.m
//  SoonZik
//
//  Created by LLC on 24/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "AllTheIncludes.h"

@implementation MenuTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initCell
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.title.textColor = [UIColor whiteColor];
    self.title.font = SOONZIK_FONT_BODY_SMALL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
