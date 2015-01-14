//
//  HeaderAlbumTableView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "HeaderAlbumTableView.h"
#import "Tools.h"
#import "SVGKImage.h"

@implementation HeaderAlbumTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initHeader
{
    self.albumImage.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.albumImage.layer.shadowOffset = CGSizeMake(5, 5);
    self.albumImage.layer.shadowRadius = 5.0;
    self.albumImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.albumImage.layer.shadowOpacity = 0.8;
    
    [self.shareButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"share"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.loveButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"love"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.artistButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"user"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
}

@end
