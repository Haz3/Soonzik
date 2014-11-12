//
//  ExploreCollectionViewCell.m
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ExploreCollectionViewCell.h"

@implementation ExploreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initCell
{
    self.imgV.layer.borderWidth = 1;
    self.imgV.layer.borderColor = [UIColor whiteColor].CGColor;
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 2.0f);
    TopBorder.backgroundColor = [UIColor grayColor].CGColor;
    [self.titleView.layer addSublayer:TopBorder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
