//
//  NewsTypeAlbumCell.m
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "NewsTypeAlbumCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsTypeAlbumCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellWithNews:(News *)news
{
    self.news = news;
    
    CGFloat borderWidth = 0.5;
    self.cellContent.layer.borderColor = [UIColor grayColor].CGColor;
    self.cellContent.layer.borderWidth = borderWidth;
    
    [self.shareButton addTarget:self action:@selector(launchShareView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)launchShareView
{
    [self.shareDelegate launchShareViewWithNews:self.news];
}

@end
