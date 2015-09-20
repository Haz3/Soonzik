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

- (void)initHeader
{
    self.albumImage.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.albumImage.layer.shadowOffset = CGSizeMake(5, 5);
    self.albumImage.layer.shadowRadius = 5.0;
    self.albumImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.albumImage.layer.shadowOpacity = 0.8;
}

@end
