//
//  NewsNouvelleCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 18/02/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "NewsNouvelleCell.h"

@implementation NewsNouvelleCell

- (void)initCellWithNews:(News *)news
{
    self.news = news;
    
    CGFloat borderWidth = 0.5;
    self.cellContent.layer.borderColor = [UIColor grayColor].CGColor;
    self.cellContent.layer.borderWidth = borderWidth;
    
    [self.shareButton addTarget:self action:@selector(launchShareView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleLabel setText:news.type];
    [self.subtitleLabel setText:news.title];
    [self.dateLabel setText:news.date];
}

- (void)launchShareView
{
    [self.shareDelegate launchShareViewWithNews:self.news andCell:self];
}

@end
