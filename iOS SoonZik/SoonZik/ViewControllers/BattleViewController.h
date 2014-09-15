//
//  BattleViewController.h
//  SoonZik
//
//  Created by LLC on 23/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "CSView.h"

@interface BattleViewController : TypeViewController


@property (weak, nonatomic) IBOutlet UILabel *artist1Label;
@property (weak, nonatomic) IBOutlet UILabel *artist2Label;
@property (weak, nonatomic) IBOutlet UIImageView *artist1Image;
@property (weak, nonatomic) IBOutlet UIImageView *artist2Image;
@property (weak, nonatomic) IBOutlet UIButton *voteArtist1;
@property (weak, nonatomic) IBOutlet UIButton *voteArtist2;

@property (weak, nonatomic) IBOutlet UILabel *artist1VoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *artist2VoteLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIView *previewSection;
@property (weak, nonatomic) IBOutlet UIView *shareSection;

@property (assign, nonatomic) float firstArtistScore;
@property (assign, nonatomic) float secondArtistScore;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *latestVotes;

@property (nonatomic, weak) IBOutlet CSView *csView;

@end
