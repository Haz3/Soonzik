//
//  PlaylistViewCell.h
//  SoonZik
//
//  Created by LLC on 18/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageAlbum;
@property (nonatomic, weak) IBOutlet UILabel *songTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;

@property (nonatomic, weak) IBOutlet UIView *layerListening;

- (void)initCell;

@end
