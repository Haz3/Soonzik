//
//  HeaderPackView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 30/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "HeaderPackView.h"
#import "Pack.h"

@implementation HeaderPackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createSliderWithPacks:(NSArray *)listOfPacks andPage:(int)index
{
    self.indexOfPage = index;
    self.listOfPacks = listOfPacks;
    
    Pack *currentPack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    
    self.packTitleLabel.text = currentPack.title;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    float imageWith = 150.0f;
    float imageEcart = (self.scrollView.frame.size.width - imageWith) / 2;
    NSLog(@"imageEcart : %f", imageEcart);
    
    self.scrollView.clipsToBounds = NO;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat contentOffset = 0.0f;
    
    for (int i = 0; i < listOfPacks.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWith + imageEcart * (i * 2 + 1), self.scrollView.frame.origin.y, imageWith, imageWith)];
        //imgV.image = [self.listOfPacks objectAtIndex:i];
        imgV.layer.backgroundColor = [UIColor blackColor].CGColor;
        imgV.layer.shadowOffset = CGSizeMake(5, 5);
        imgV.layer.shadowRadius = 5.0;
        imgV.layer.shadowColor = [UIColor blackColor].CGColor;
        imgV.layer.shadowOpacity = 0.8;
        [self.scrollView addSubview:imgV];
        contentOffset += self.scrollView.frame.size.width;
        
    }
    self.scrollView.contentSize = CGSizeMake(contentOffset, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake((contentOffset / listOfPacks.count) * self.indexOfPage, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSLog(@"index : %i", self.indexOfPage);
    Pack *pack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    self.packTitleLabel.text = pack.title;
    
    [self.slideDelegate changeIndex:self.indexOfPage];
}

@end
