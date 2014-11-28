//
//  HeaderPackView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 30/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlidePacksDelegate <NSObject>

- (void)changeIndex:(int)index;

@end

@interface HeaderPackView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic) int indexOfPage;
@property (nonatomic, weak) IBOutlet UILabel *packTitleLabel;

@property (nonatomic, strong) NSArray *listOfPacks;

@property (nonatomic, strong) id<SlidePacksDelegate> slideDelegate;

- (void)createSliderWithPacks:(NSArray *)listOfPacks andPage:(int)index;

@end
