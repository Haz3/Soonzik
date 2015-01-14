//
//  TitlePlaylistCollectionViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 11/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitlePlaylistCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *album1Image;
@property (nonatomic, weak) IBOutlet UIImageView *album2Image;
@property (nonatomic, weak) IBOutlet UIImageView *album3Image;
@property (nonatomic, weak) IBOutlet UIImageView *album4Image;

@property (nonatomic, weak) IBOutlet UIView *containView;

@property (nonatomic, weak) IBOutlet UILabel *playlistTitle;
@property (nonatomic, weak) IBOutlet UILabel *nbrOfTracks;

- (void)initCell;

@end
