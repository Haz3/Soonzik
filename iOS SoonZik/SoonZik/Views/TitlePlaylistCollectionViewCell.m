//
//  TitlePlaylistCollectionViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 11/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "TitlePlaylistCollectionViewCell.h"

@implementation TitlePlaylistCollectionViewCell

- (void)initCell
{
    self.containView.layer.borderWidth = 1;
    self.containView.layer.borderColor = [UIColor whiteColor].CGColor;
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 2.0f);
    TopBorder.backgroundColor = [UIColor grayColor].CGColor;
    [self.containView.layer addSublayer:TopBorder];
}

@end
