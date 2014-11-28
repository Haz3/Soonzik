//
//  BattleViewController.h
//  SoonZik
//
//  Created by LLC on 23/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "CSView.h"

@interface BattleViewController : TypeViewController <UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;

@property (assign, nonatomic) float firstArtistScore;
@property (assign, nonatomic) float secondArtistScore;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentView2;

@property (nonatomic, weak) IBOutlet CSView *csView;

@property (nonatomic, weak) IBOutlet UIView *firstArtistView;
@property (nonatomic, weak) IBOutlet UIImageView *firstArtistViewImage;
@property (nonatomic, weak) IBOutlet UILabel *firstArtistViewName;
@property (nonatomic, weak) IBOutlet UIButton *firstArtistViewButton;
@property (nonatomic, weak) IBOutlet UIView *secondArtistView;
@property (nonatomic, weak) IBOutlet UIImageView *secondArtistViewImage;
@property (nonatomic, weak) IBOutlet UILabel *secondArtistViewName;
@property (nonatomic, weak) IBOutlet UIButton *secondArtistViewButton;

@property (nonatomic, weak) IBOutlet UIView *okView;
@property (nonatomic, weak) IBOutlet UIView *nokView;

@end
